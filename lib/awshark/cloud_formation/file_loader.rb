# frozen_string_literal: true

module Awshark
  module CloudFormation
    class FileLoader
      attr_reader :path

      def initialize(path)
        @path = path
      end

      # @returns [Hash]
      def template
        filepath = if File.directory?(path)
                     Dir.glob("#{path}/template.*").detect do |f|
                       %w[.json .yml .yaml].include?(File.extname(f))
                     end
                   else
                     path
                   end

        parse_file(filepath)
      end

      # @returns [Hash]
      def parameters
        return {} if File.file?(path)

        filepath = Dir.glob("#{path}/parameters.*").detect do |f|
          %w[.json .yml .yaml].include?(File.extname(f))
        end
        return {} if filepath.blank?

        parse_file(filepath) || {}
      end

      private

      def parse_file(filepath)
        content = File.read(filepath)

        case File.extname(filepath)
        when '.json'
          JSON.parse(content)
        when '.yml', '.yaml'
          YAML.safe_load(content, [Date, Time])
        else
          raise ArgumentError, "Unsupported file extension for #{filepath}"
        end
      end
    end
  end
end
