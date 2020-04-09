# frozen_string_literal: true

module Awshark
  module Managers
    class S3
      def list_objects(bucket:, prefix: nil)
        response = client.list_objects_v2({
          bucket: bucket,
          prefix: prefix
        })

        response.contents.to_a.select { |o| o.size > 0 }
      end

      private

      def client
        @client ||= Aws::S3::Client.new(
          region: Aws.config[:region] || 'eu-central-1',
          signature_version: 'v4'
        )
      end
    end
  end
end
