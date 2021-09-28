# frozen_string_literal: true

#
# https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/CloudFormation/Client.html
#
module Awshark
  module CloudFormation
    class Manager
      attr_reader :path, :options
      attr_reader :stack, :stage, :capabilities

      def initialize(path, options = {})
        @path = path
        @options = options
        @stage = options[:stage]

        @capabilities = if options[:iam]
                          %w[CAPABILITY_IAM CAPABILITY_NAMED_IAM]
                        else
                          []
                        end

        @stack = Stack.new(name: inferrer.stack_name)
      end

      def diff_stack_template
        new_template = template.body
        old_template = stack.template
        options = { context: 2 }

        diff = Diffy::Diff.new(old_template, new_template, options)
        diff.to_s(:color)
      end

      def update_stack
        stack.create_or_update(
          capabilities: capabilities,
          stack_name: stack.name,
          template_url: template.url,
          parameters: parameters.stack_parameters
        )
      rescue Aws::CloudFormation::Errors::ValidationError => e
        raise GracefulFail, e.message if e.message.match(/No updates are to be performed/)
        raise GracefulFail, e.message if e.message.match(/ROLLBACK_COMPLETE state and can not be updated/)

        raise e
      end

      def tail_stack_events
        stack.reload
        stack_events = StackEvents.new(stack)

        loop do
          events = stack_events.new_events
          print_stack_events(events)

          break if stack_events.done?

          sleep(event_polling)
        end

        (id = options[:api_gateway]) && deploy_api_gateway(id)
      end

      private

      def deploy_api_gateway(rest_api_id)
        client = Aws::APIGateway::Client.new
        client.create_deployment(
          rest_api_id: rest_api_id,
          stage_name: stage
        )
      end

      def event_polling
        Awshark.config.cloud_formation.event_polling || 3
      end

      def inferrer
        @inferrer ||= Inferrer.new(path, stage)
      end

      def parameters
        @parameters ||= Parameters.new(path: path, stage: stage)
      end

      def template
        @template ||= Template.new(path, options.merge(name: stack.name))
      end

      def print_stack_events(events)
        $stdout.sync
        events.each do |event|
          printf "%-50<type>s %-30<logical_id>s %-20<status>s %<reason>s\n",
                 type: event.resource_type,
                 logical_id: event.logical_resource_id,
                 status: event.resource_status,
                 reason: event.resource_status_reason
        end
      end
    end
  end
end
