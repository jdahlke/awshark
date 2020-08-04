# frozen_string_literal: true

module Awshark
  module S3
    class Manager
      def list_objects(bucket:, prefix: nil)
        objects = []
        response = client.list_objects_v2(bucket: bucket, prefix: prefix)
        objects = objects.concat(response.contents)

        while response.next_continuation_token
          response = client.list_objects_v2(
            bucket: bucket,
            prefix: prefix,
            continuation_token: response.next_continuation_token
          )
          objects = objects.concat(response.contents)
        end

        objects.select { |o| o.size.positive? }
      end

      def update_object_metadata(bucket, key, options = {})
        raise ArgumentError, 'meta=acl:STRING is missing' if options[:acl].blank?

        object = client.get_object(bucket: bucket, key: key)
        metadata = object.metadata.merge(options[:metadata] || {})
        artifact = Artifact.new(key)

        # copy object in place to update metadata
        client.copy_object(
          acl: options[:acl] || 'private',
          bucket: bucket,
          copy_source: "/#{bucket}/#{key}",
          key: key,
          cache_control: options[:cache_control] || object.cache_control,
          content_type: artifact.content_type,
          metadata: metadata.stringify_keys,
          metadata_directive: 'REPLACE',
          server_side_encryption: 'AES256'
        )
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
