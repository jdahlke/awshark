require 'awshark/version'

require 'active_support/all'
require 'thor'
require 'yaml'

module Awshark
  class Error < StandardError; end
  # Your code goes here...
end

require 'awshark/cli'
