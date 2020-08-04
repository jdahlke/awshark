# frozen_string_literal: true

require 'aws-sdk-s3'
require 'mini_mime'

require 'awshark/s3/artifact'
require 'awshark/s3/manager'

module Awshark
  module Subcommands
    class S3 < Thor
      include Awshark::Subcommands::ClassOptions
      include ActiveSupport::NumberHelper

      desc 'objects', 'List objects of an S3 bucket'
      long_desc <<-LONGDESC
        List objects of an S3 bucket

        Example: `awshark s3 objects BUCKET PREFIX`
      LONGDESC
      def objects(bucket, prefix = '')
        process_class_options

        objects = manager.list_objects(bucket: bucket, prefix: prefix)

        objects.each do |o|
          filesize = number_to_human_size(o.size)
          printf "  %-10<size>s %<key>s\n", key: o.key, size: filesize
        end
        printf "\n\n  Total:\n"
        printf "  %<size>s objects\n", size: objects.size
        printf "  %<size>s\n", size: number_to_human_size(objects.map(&:size).sum)
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

          printf " %<key>s \n", key: o.key
        end
      end

      private

      def manager
        @manager ||= Awshark::S3::Manager.new
      end
    end
  end
end
