# frozen_string_literal: true

module Awshark
  module CloudFormation
    class Parameters
      attr_reader :stage

      def initialize(data:, stage:)
        if stage
          @stage = stage
          @params = params_for_stage(data)
        else
          @params = data || {}
        end
      end

      def to_hash
        @params
      end

      def stack_parameters
        @params.each.map do |k, v|
          {
            parameter_key: k,
            parameter_value: v
          }
        end
      end

      private

      def params_for_stage(data)
        params = if data.key?(stage)
                   data[stage]
                 else
                   data
                 end
        params.merge(Stage: stage)
      end
    end
  end
end
