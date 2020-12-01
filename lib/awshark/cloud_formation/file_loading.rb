# frozen_string_literal: true

module Awshark
  module CloudFormation
    module FileLoading
      def load_file(filepath, context = nil)
        return nil if filepath.blank?

        content = File.read(filepath)
        content = ERB.new(content).result_with_hash(context) if context.present?

        case File.extname(filepath)
        when '.json'
          JSON.parse(content)
        when '.yml', '.yaml'
          YAML.safe_load(content, permitted_classes: [Date, Time], aliases: true)
        else
          raise ArgumentError, "Unsupported file extension for #{filepath}"
        end
      end
    end
  end
end
