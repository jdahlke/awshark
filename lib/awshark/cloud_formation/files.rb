# frozen_string_literal: true

module Awshark
  module CloudFormation
    module Files
      def parse_file(filepath)
        return nil if filepath.blank?

        content = File.read(filepath)

        parse_string(filepath, content)
      end

      def parse_string(filename, content)
        case File.extname(filename)
        when '.json'
          JSON.parse(content)
        when '.yml', '.yaml'
          YAML.safe_load(content, permitted_classes: [Date, Time], aliases: true)
        else
          raise ArgumentError, "Unsupported file extension for parsing, #{filepath}"
        end
      end
    end
  end
end
