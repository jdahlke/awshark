# frozen_string_literal: true

require 'active_support/all'
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
end

require 'awshark/cli'
