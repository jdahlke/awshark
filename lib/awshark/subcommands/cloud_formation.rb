# frozen_string_literal: true

require 'aws-sdk-cloudformation'
require 'diffy'

require 'awshark/cloud_formation/file_loader'
require 'awshark/cloud_formation/inferrer'
require 'awshark/cloud_formation/manager'
require 'awshark/cloud_formation/parameters'
require 'awshark/cloud_formation/stack'
require 'awshark/cloud_formation/stack_events'

module Awshark
  module Subcommands
    class CloudFormation < Thor
      include Awshark::Subcommands::ClassOptions

      class_option :stage, type: :string, desc: 'Stage of the configuration'

      desc 'deploy', 'Updates or creates an AWS CloudFormation stack'
      long_desc <<-LONGDESC
        Updates or creates a CloudFormation stack on AWS.

        awshark cf deploy TEMPLATE_PATH CAPABILITIES

        Examples:

          awshark cf deploy foo_template

          awshark cf deploy iam_template IAM
      LONGDESC
      def deploy(template_path, iam = '')
        process_class_options

        manager = create_manager(template_path, iam == 'IAM')
        print_stack_information(manager.stack)

        manager.update_stack
        sleep(2)
        manager.tail_stack_events
      rescue GracefulFail => e
        puts e.message
      end

      desc 'diff', 'Show diff between local stack template and AWS CloudFormation'
      long_desc <<-LONGDESC
        Shows colored diff between local stack template and AWS CloudFormation

        Example: `awshark cf diff TEMPLATE_PATH`
      LONGDESC
      def diff(template_path)
        process_class_options

        manager = create_manager(template_path)
        print_stack_information(manager.stack)

        diff = manager.diff_stack_template
        puts diff
      end

      private

      def create_manager(template_path, iam = false)
        Awshark::CloudFormation::Manager.new(
          path: template_path,
          stage: options['stage'],
          iam: iam
        )
      end

      def print_stack_information(stack)
        if stack.exists?
          args = { name: stack.name, created_at: stack.creation_time }
          printf "Stack: %-20<name>s (created at %<created_at>s)\n\n", args
        else
          printf "Stack: %<name>s\n\n", name: stack.name
        end
      end
    end
  end
end
