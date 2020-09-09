# frozen_string_literal: true

module Awshark
  module CloudFormation
    module FileLoading
      def load_file(filepath)
        return nil if filepath.blank?

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
