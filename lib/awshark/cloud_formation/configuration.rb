# frozen_string_literal: true

module Awshark
  module CloudFormation
    class Configuration
      attr_reader :event_polling

      def initialize
        @event_polling = 3
      end

      def client
        @client ||= begin
                      region = Aws.config[:region]
                      Aws::CloudFormation::Client.new(region: region)
                    end
      end

      attr_writer :client
    end
  end
end
