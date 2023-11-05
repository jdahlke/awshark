# frozen_string_literal: true

module Awshark
  module CloudFormation
    class Template
      include Files

      attr_reader :path
      attr_reader :bucket, :name, :stage, :format

      def initialize(path, options = {})
        @path = path

        @bucket_and_path = options[:bucket]
        @bucket = (options[:bucket] || '').split('/')[0]
        @name = options[:name]
        @stage = options[:stage]
        @format = options[:format] || 'yaml'
      end

      # @returns String
      def body
        return nil if template_path.blank?

        content = File.read(template_path)
        content = ERB.new(content).result_with_hash(context)

        if format == 'json'
          json = parse_string(template_path, content)
          return JSON.pretty_generate(json)
        end

        content
      end

      # @returns [Hash]
      def context
        @context ||=
          begin
            context = parse_file(context_path) || {}
            context = context[stage] if context.key?(stage)

            {
              context: RecursiveOpenStruct.new(context),
              aws_account_id: Awshark.config.sts.aws_account_id,
              stage: stage,
              ssm: ssm
            }
          end
      end

      # @returns [Integer]
      def size
        body.size
      end

      # @returns [Boolean]
      def uploaded?
        @uploaded == true
      end

      # @returns [String]
      def url
        upload unless uploaded?

        "https://#{bucket}.s3.#{region}.amazonaws.com/#{s3_key}"
      end

      private

      def ssm
        proc do |key|
          @ssm_client ||= Aws::SSM::Client.new
          @ssm_client.get_parameter(name: key, with_decryption: true)&.parameter&.value
        end
      end

      def region
        Awshark.config.s3.region
      end

      def s3
        Awshark.config.s3.client
      end

      def s3_key
        return @s3_key if defined?(@s3_key)

        _, *tail = @bucket_and_path.split('/')
        prefix = [*tail, 'awshark', name].join('/')
        @s3_key = "#{prefix}/#{Time.now.strftime('%Y-%m-%d')}.json"
      end

      def upload
        raise ArgumentError, 'Bucket for template upload to S3 is missing' if bucket.blank?

        Awshark.logger.debug "[awshark] Uploading CF template to #{bucket}"

        s3.put_object(bucket: bucket, key: s3_key, body: body)
      end

      def context_path
        Dir.glob("#{path}/context.*").detect do |f|
          %w[.json .yml .yaml].include?(File.extname(f))
        end
      end

      def template_path
        @template_path ||= if File.directory?(path)
                             Dir.glob("#{path}/template.*").detect do |f|
                               %w[.json .yml .yaml].include?(File.extname(f))
                             end
                           else
                             path
                           end
      end
    end
  end
end
