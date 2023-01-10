# frozen_string_literal: true

module Awshark
  module ClassOptions
    def process_class_options
      command = current_command_chain.last
      cli_options = options.merge(parent_options || {}).symbolize_keys

      if cli_options[:help]
        respond_to?(command) ? help(command) : help
        exit(0)
      end

      setup_aws_credentials(cli_options)
    end

    private

    def setup_aws_credentials(options)
      profile_resolver = ProfileResolver.new(options)

      ::Aws.config[:region] = profile_resolver.region
      ::Aws.config[:credentials] = profile_resolver.credentials
    end
  end
end
