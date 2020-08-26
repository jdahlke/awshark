# frozen_string_literal: true

module Awshark
  module Rds
    class CheckReservations
      attr_reader :instances, :reservations

      def initialize(instances:, reservations:)
        @instances = instances
        @reservations = reservations
      end

      def type_permutations
        type_permutations_hash = {}

        (reservations + instances).each do |instance|
          key = "#{instance.type}+#{instance.multi_az}"
          type_permutations_hash[key] = {
            type: instance.type,
            multi_az: instance.multi_az
          }
        end

        type_permutations_hash.values
      end

      def check
        type_permutations.map do |permutation|
          type = permutation[:type]
          multi_az = permutation[:multi_az]

          instance_count = count_instances(type, multi_az)
          reserved_count = count_reservations(type, multi_az)

          OpenStruct.new(
            type: type,
            multi_az: multi_az,
            instance_count: instance_count,
            reserved_count: reserved_count
          )
        end
      end

      def count_instances(type, multi_az)
        instances.select do |i|
          i.type == type && i.multi_az == multi_az
        end.size
      end

      def count_reservations(type, multi_az)
        reservation = reservations.detect do |r|
          r.type == type && r.multi_az == multi_az
        end

        reservation ? reservation.count : 0
      end
    end
  end
end
