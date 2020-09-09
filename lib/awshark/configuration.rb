# frozen_string_literal: true

module Awshark
  class Configuration
    attr_accessor :cloud_formation

    def initialize
      @cloud_formation = OpenStruct.new(
        client: nil,
        event_polling: 3
      )
    end
  end
end
