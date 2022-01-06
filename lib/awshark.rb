# frozen_string_literal: true

require 'active_support/all'
require 'logger'
require 'thor'
require 'yaml'

require 'awshark/version'
require 'awshark/concerns/logging'
require 'awshark/cloud_formation/configuration'
require 'awshark/ec2/configuration'
require 'awshark/ecs/configuration'
require 'awshark/s3/configuration'
require 'awshark/sts/configuration'

module Awshark
  class GracefulFail < StandardError; end

  def self.config
    @config ||= begin
                  cf = CloudFormation::Configuration.new
                  ec2 = Ec2::Configuration.new
                  ecs = Ecs::Configuration.new
                  s3 = S3::Configuration.new
                  sts = Sts::Configuration.new

                  OpenStruct.new(
                    cloud_formation: cf,
                    ec2: ec2,
                    ecs: ecs,
                    s3: s3,
                    sts: sts
                  )
                end
  end

  def self.configure
    yield config
  end

  def self.logger
    return @logger if @logger

    @logger = ::Logger.new($stdout)
    @logger.level = Logger::INFO
    @logger.formatter = proc do |_severity, _datetime, _progname, msg|
      "[awshark] #{msg}\n"
    end

    @logger
  end
end

require 'awshark/cli'
