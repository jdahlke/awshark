# frozen_string_literal: true

module Awshark
  module CloudFormation
    class Template
      include FileLoading

      attr_reader :filepath, :path, :stage

      def initialize(path:, stage: nil)
        @path = path
        @stage = stage

        @filepath = if File.directory?(path)
                      Dir.glob("#{path}/template.*").detect do |f|
                        %w[.json .yml .yaml].include?(File.extname(f))
                      end
                    else
                      path
                    end
      end

      # @returns [Hash]
      def as_json
        load_file(filepath, context)
      end

      # @returns [String]
      def body
        JSON.pretty_generate(as_json)
      end

      # @returns [Hash]
      def context
        return { context: {}, stage: stage } if File.file?(path)

        filepath = Dir.glob("#{path}/context.*").detect do |f|
          %w[.json .yml .yaml].include?(File.extname(f))
        end

        context = load_file(filepath) || {}
        context = context[stage] if context.key?(stage)

        {
          context: HashWithIndifferentAccess.new(context),
          aws_account_id: Awshark.config.aws_account_id,
          stage: stage
        }
      end
    end
  end
end
