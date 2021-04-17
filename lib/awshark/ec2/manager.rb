# frozen_string_literal: true

module Awshark
  module EC2
    class Manager
      def all_instances
        return @all_instances if defined?(@all_instances)

        @all_instances = []
        response = client.describe_instances

        response.each_page do |page|
          page.reservations.each do |reservation|
            reservation.instances.each do |instance|
              @all_instances << Instance.new(instance)
            end
          end
        end

        @all_instances
      end

      %i[running stopped terminated].each do |state|
        define_method "#{state}_instances" do
          all_instances.select { |i| i.state == state.to_s }
        end
      end

      private

      def client
        @client ||= Aws::EC2::Client.new(region: region)
      end

      def region
        Aws.config[:region] || 'eu-central-1'
      end
    end
  end
end
