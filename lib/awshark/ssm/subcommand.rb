# frozen_string_literal: true

require 'aws-sdk-ssm'

require 'awshark/ssm/client'

module Awshark
  module Ssm
    class Subcommand < Thor
      include Awshark::ClassOptions

      class_option :stage, type: :string, desc: 'Stage of the configuration'

      desc 'list', 'Lists Parameter Store secrets'
      long_desc <<-LONGDESC
        List AWS Parameter Store secrets of specific path.

        awshark ssm list PARAMETER_PATH

        Examples:

          awshark ssm list /ticketing-api
      LONGDESC
      def list(parameter_path)
        process_class_options

        raise GracefulFail, 'PARAMETER_PATH must begin with a "/"' if parameter_path[0] != '/'

        puts "Parameter Store #{parameter_path.inspect} in #{::Aws.config[:region]}:"

        parameters = ssm_client.list_secrets(application: parameter_path)

        parameters.each do |param|
          printf " %-60<name>s %<value>s\n", { name: param.name, value: param.value }
        end
      rescue GracefulFail => e
        puts e.message
      end

      desc 'deploy', 'Updates Parameter Store secrets'
      long_desc <<-LONGDESC
        Updates AWS Parameter Store secrets from a file "secrets.yml".
        It assumes the directory is the name of the application.

        awshark ssm deploy DIRECTORY --stage=STAGE

        Examples:

          awshark ssm deploy aws/ticketing-api --stage=staging
      LONGDESC
      def deploy(directory)
        process_class_options

        secrets_path = File.join(directory, 'secrets.yml')
        raise GracefulFail, "File #{secrets_path} does not exist." unless File.exist?(secrets_path)

        app_name = directory.split('/').last
        stage = options['stage']

        secrets = YAML.load_file(secrets_path)[stage]
        raise GracefulFail, "No secrets found for stage '#{stage}' in #{secrets_path}." if secrets.nil?

        ssm_client.update_secrets(application: "#{app_name}-#{stage}", secrets: secrets)
      rescue GracefulFail => e
        puts e.message
      end

      private

      def ssm_client
        @ssm_client ||= Awshark::Ssm::Client.new
      end
    end
  end
end
