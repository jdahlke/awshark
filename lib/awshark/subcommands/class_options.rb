# frozen_string_literal: true

module Awshark
  module Subcommands
    module ClassOptions
      def process_class_options
        command = current_command_chain.last
        cli_options = options.merge(parent_options || {})

        if cli_options[:help]
          respond_to?(command) ? help(command) : help
          exit(0)
        end

        set_aws_profile(cli_options[:profile]) if cli_options[:profile]
        set_aws_region(cli_options[:region]) if cli_options[:region]
      end

      private
      def set_aws_profile(profile_name)
        credentials = ::Aws::SharedCredentials.new(profile_name: profile_name)
        ::Aws.config[:credentials] = credentials
      end

      def set_aws_region(region)
        ::Aws.config[:region] = region
      end
    end
  end
end
