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

      def update_object_metadata(bucket, key, options = {})
        raise ArgumentError, 'meta=acl:STRING is missing' if options[:acl].blank?

        object = client.get_object(bucket: bucket, key: key)
        metadata = object.metadata.merge(options[:metadata] || {})

        # copy object in place to update metadata
        client.copy_object({
          acl: options[:acl] || 'private',
          bucket: bucket,
          copy_source: "/#{bucket}/#{key}",
          key: key,
          cache_control: options[:cache_control] || object.cache_control,
          content_type: content_type(key),
          metadata: metadata.stringify_keys,
          metadata_directive: 'REPLACE',
          server_side_encryption: 'AES256'
        })
      end

      private

      def client
        @client ||= Aws::S3::Client.new(
          region: Aws.config[:region] || 'eu-central-1',
          signature_version: 'v4'
        )
      end

      def content_type(filename)
        mime = MiniMime.lookup_by_filename(filename)
        if mime
          mime.content_type
        else
          'application/octet-stream'
        end
      end
    end
  end
end
