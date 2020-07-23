# frozen_string_literal: true

# TODO db clusters

module Awshark
  module Rds
    class Manager
      def instances
        return @instances  if defined?(@instances)

        @instances = []
        response = client.describe_db_instances

        response[:db_instances].each do |instance|
          @instances << OpenStruct.new({
            name: instance[:db_instance_identifier],
            type: instance[:db_instance_class],
            state: instance[:db_instance_status],
            multi_az: instance[:multi_az],
            engine: instance[:engine],
            engine_version: instance[:engine_version],
            encrypted: instance[:storage_encrypted],
            storage_type: instance[:storage_type]
          })
        end

        @instances
      end

      def reservations
        return @reservations  if defined?(@reservations)

        response = client.describe_reserved_db_instances

        @reservations = response[:reserved_db_instances].map do |instance|
          OpenStruct.new({
            count: instance[:db_instance_count],
            type: instance[:db_instance_class],
            multi_az: instance[:multi_az],
            state: instance[:state],
            offering_type: instance[:offering_type],
          })
        end.select { |ri| ri[:state] == 'active' }

        @reservations
      end

      def check_reservations
        CheckReservations.new(instances: instances, reservations: reservations).check
      end

      private

      def client
        @client ||= Aws::RDS::Client.new(
          region: Aws.config[:region] || 'eu-central-1'
        )
      end
    end
  end
end
