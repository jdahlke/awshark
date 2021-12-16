# frozen_string_literal: true

require 'awshark/profile_resolver'

require 'awshark/subcommands/class_options'
require 'awshark/subcommands/cloud_formation'
require 'awshark/subcommands/ec2'
require 'awshark/subcommands/ecs'
require 'awshark/subcommands/rds'
require 'awshark/subcommands/s3'

module Awshark
  class Cli < Thor
    package_name 'Awshark'

    map '-v' => :version

    class_option :help, type: :boolean, desc: 'Prints this help'

    desc 'cf COMMAND', 'Run CloudFormation command'
    subcommand 'cf', Awshark::Subcommands::CloudFormation

    desc 'ec2 COMMAND', 'Run EC2 command'
    subcommand 'ec2', Awshark::Subcommands::Ec2

    desc 'ecs COMMAND', 'Run ECS command'
    subcommand 'ecs', Awshark::Subcommands::Ecs

    desc 'rds COMMAND', 'Run RDS command'
    subcommand 'rds', Awshark::Subcommands::Rds

    desc 's3 COMMAND', 'Run CloudFormation command'
    subcommand 's3', Awshark::Subcommands::S3

    desc 'version', 'Displays current version of AwsShark'
    long_desc <<-LONGDESC
        Displays current version of AwsShark.
    LONGDESC
    def version
      puts "AwShark version: #{Awshark::VERSION}"
    end
  end
end
