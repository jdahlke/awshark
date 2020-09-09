# frozen_string_literal: true

module Awshark
  module CloudFormation
    class Parameters
      include FileLoading

      attr_reader :stage

      def initialize(path:, stage: nil)
        @filepath = Dir.glob("#{path}/parameters.*").detect do |f|
          %w[.json .yml .yaml].include?(File.extname(f))
        end
        @stage = stage
      end

      def params
        @params ||= load_parameters(@filepath)
      end

      def to_hash
        params
      end

      def stack_parameters
        params.each.map do |k, v|
          {
            parameter_key: k,
            parameter_value: v
          }
        end
      end

      private

      def load_parameters(filepath)
        data = load_file(filepath) || {}

        data[stage] || data
      end
    end
  end
end
