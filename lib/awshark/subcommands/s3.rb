# frozen_string_literal: true

require 'aws-sdk-s3'
require 'awshark/managers/s3'

module Awshark
  module Subcommands
    class S3 < Thor
      include Awshark::Subcommands::ClassOptions
      include ActiveSupport::NumberHelper

      desc 'list', 'List objects of an S3 bucket'
      long_desc <<-LONGDESC
        List objects of an S3 bucket

        Example: `awshark s3 list BUCKET PREFIX`
      LONGDESC
      def list(bucket, prefix = '/')
        process_class_options

        objects = manager.list_objects(bucket: bucket, prefix: prefix)

        objects.each do |o|
          uri = "#{bucket}/#{o.key}"
          filesize = number_to_human_size(o.size)

          printf "%-120s %s\n", uri, filesize
        end
      end

      private

      def manager
        @manager ||= Awshark::Managers::S3.new
      end
    end
  end
end
