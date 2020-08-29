# frozen_string_literal: true

module Awshark
  class Configuration
    attr_accessor :cloud_formation

    def initialize
      @cloud_formation = OpenStruct.new
    end
  end
end
