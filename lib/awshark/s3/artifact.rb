# frozen_string_literal: true

module Awshark
  module S3
    class Artifact
      attr_reader :key

      def initialize(key)
        @key = key
      end

      def cache_control
        return "public, max-age=#{1.year.to_i}, s-maxage=#{1.year.to_i}" if fingerprint?

        'public, max-age=0, s-maxage=120, must-revalidate'
      end

      def fingerprint?
        return false if key.blank?

        basename.match(/\.([0-9a-f]{20}|[0-9a-f]{32})\./).present?
      end

      def content_type
        mime = MiniMime.lookup_by_filename(basename)
        if mime
          mime.content_type
        else
          'application/octet-stream'
        end
      end

      def basename
        ::File.basename(key)
      end
    end
  end
end
