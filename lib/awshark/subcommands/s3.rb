# frozen_string_literal: true

require 'aws-sdk-s3'
require 'mini_mime'

require 'awshark/s3/manager'

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

      desc 'update_metadata', 'Update metadata of S3 objects'
      long_desc <<-LONGDESC
         Update metadata of S3 objects

        Example: `awshark s3 update_metadata BUCKET PREFIX --meta="cache_control:public, max-age=0, s-maxage=120, must-revalidate" acl:public-read`
      LONGDESC
      method_options meta: :hash
      def update_metadata(bucket, prefix)
        process_class_options

        objects = manager.list_objects(bucket: bucket, prefix: prefix)
        meta = (options[:meta] || {}).symbolize_keys

        puts "Metadata: #{JSON.pretty_generate(meta)}"
        puts 'Updating ...'
        objects.each do |o|
          manager.update_object_metadata(bucket, o.key, meta)

          printf "  %-120s \n", "#{bucket}/#{o.key}"
        end
      end

      private

      def manager
        @manager ||= Awshark::S3::Manager.new
      end
    end
  end
end
