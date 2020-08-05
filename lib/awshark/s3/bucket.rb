# frozen_string_literal: true

module Awshark
  module S3
    class Bucket
      attr_reader :name, :creation_date, :region

      def initialize(attributes)
        @name = attributes.name
        @creation_date = attributes.creation_date
        @region = attributes.region

        # fixes S3 quirks
        @region = 'eu-west-1' if @region == 'EU'
      end

      def byte_size
        metric_value(metric_name: 'BucketSizeBytes', storage_type: 'StandardStorage')
      end

      def number_of_objects
        metric_value(metric_name: 'NumberOfObjects', storage_type: 'AllStorageTypes')
      end

      private

      def cloudwatch
        @cloudwatch ||= Aws::CloudWatch::Client.new(region: region)
      end

      def metric_value(metric_name:, storage_type:)
        return 0 unless region.present?

        response = cloudwatch.get_metric_statistics(
          namespace: 'AWS/S3',
          metric_name: metric_name,
          dimensions: [
            {
              name: 'BucketName',
              value: name
            },
            {
              name: 'StorageType',
              value: storage_type
            }
          ],
          start_time: Time.now - 7.days,
          end_time: Time.now,
          period: 86_400,
          statistics: ['Average']
        )
        return 0 if response.datapoints.empty?

        sorted_datapoints = response.datapoints.sort_by(&:timestamp)
        sorted_datapoints.last.average
      end
    end
  end
end
