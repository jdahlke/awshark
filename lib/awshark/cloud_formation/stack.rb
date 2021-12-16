# frozen_string_literal: true

require 'forwardable'

#
# https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/CloudFormation/Types/Stack.html
#
module Awshark
  module CloudFormation
    class Stack
      extend Forwardable

      attr_reader :name

      def_delegators :@stack,
                     :stack_id,
                     :stack_name,
                     :description,
                     :parameters,
                     :creation_time,
                     :deletion_time,
                     :last_updated_time,
                     :stack_status,
                     :stack_status_reason,
                     :notification_arns,
                     :capabilities,
                     :outputs,
                     :role_arn,
                     :tags

      def initialize(name:)
        @name = name
        @stack = get_stack(name)
      end

      # @return [Boolean]
      def exists?
        @stack.present?
      end

      def events
        response = client.describe_stack_events(stack_name: stack_id)
        response.stack_events
      end

      def create_or_update(params)
        if exists?
          client.update_stack(params)
        else
          client.create_stack(params)
        end
      end

      def reload
        @stack = get_stack(name)

        self
      end

      # @return [Hash]
      def template
        return nil unless exists?
        return @template if @template.present?

        response = client.get_template(stack_name: stack_id)
        @template = response.template_body
      end

      private

      def client
        Awshark.config.cloud_formation.client
      end

      def get_stack(stack_name)
        response = begin
                     client.describe_stacks(stack_name: stack_name)
                   rescue Aws::CloudFormation::Errors::ValidationError
                     @stack = nil
                     return
                   end

        if response.stacks.length > 1
          raise ArgumentError, "Found too many stacks with name #{stack_name}. There should only be one."
        end

        response.stacks[0]
      end
    end
  end
end
