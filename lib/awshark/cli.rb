# frozen_string_literal: true

require 'awshark/profile_resolver'
require 'awshark/class_options'
require 'awshark/cloud_formation/subcommand'
require 'awshark/ec2/subcommand'
require 'awshark/ecs/subcommand'
require 'awshark/rds/subcommand'
require 'awshark/s3/subcommand'
require 'awshark/ssm/subcommand'

module Awshark
  class Cli < Thor
    package_name 'Awshark'

    map '-v' => :version

    class_option :help, type: :boolean, desc: 'Prints this help'
    class_option :region, type: :string, desc: 'AWS region'

    desc 'cf COMMAND', 'Run CloudFormation command'
    subcommand 'cf', Awshark::CloudFormation::Subcommand

    desc 'ec2 COMMAND', 'Run EC2 command'
    subcommand 'ec2', Awshark::Ec2::Subcommand

    desc 'ecs COMMAND', 'Run ECS command'
    subcommand 'ecs', Awshark::Ecs::Subcommand

    desc 'rds COMMAND', 'Run RDS command'
    subcommand 'rds', Awshark::Rds::Subcommand

    desc 's3 COMMAND', 'Run CloudFormation command'
    subcommand 's3', Awshark::S3::Subcommand

    desc 'ssm COMMAND', 'Run SSM command'
    subcommand 'ssm', Awshark::Ssm::Subcommand

    desc 'version', 'Displays current version of AwsShark'
    long_desc <<-LONGDESC
        Displays current version of AwsShark.
    LONGDESC
    def version
      puts "AwShark version: #{Awshark::VERSION}"
    end
  end
end
