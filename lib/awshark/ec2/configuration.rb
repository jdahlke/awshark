# frozen_string_literal: true

module Awshark
  module Ec2
    class Configuration
      def client
        region = Aws.config[:region] || 'eu-central-1'
        @client ||= Aws::EC2::Client.new(region: region)
      end

      attr_writer :client
    end
  end
end
