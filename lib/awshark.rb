# frozen_string_literal: true

require 'active_support/all'
require 'logger'
require 'thor'
require 'yaml'

require 'awshark/version'
require 'awshark/configuration'

module Awshark
  class GracefulFail < StandardError; end

  def self.config
    @config ||= Configuration.new
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
