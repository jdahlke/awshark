# frozen_string_literal: true

module Awshark
  module S3
    class Configuration
      def client
        @client ||= Aws::S3::Client.new(region: region, signature_version: 'v4')
      end

      def region
        Aws.config[:region] || 'eu-central-1'
      end

      attr_writer :client
    end
  end
end
