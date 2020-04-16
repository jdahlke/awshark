# frozen_string_literal: true

module Awshark
  module EC2
    class Manager
      def all_instances
        return @all_instances  if defined?(@all_instances)

        @all_instances = []
        response = client.describe_instances

        response.each_page do |page|
          page.reservations.each do |reservation|
            reservation.instances.each do |instance|
              name = instance_name(instance.tags)

              @all_instances << OpenStruct.new({
                id: instance.instance_id,
                name: name,
                type: instance.instance_type,
                state: instance.state.name,
                private_ip_address: instance.private_ip_address,
                public_ip_address: instance.public_ip_address,
                public_dns_name: instance.public_dns_name,
                vpc_id: instance.vpc_id,
                subnet_id: instance.subnet_id
              })
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
        @client ||= Aws::EC2::Client.new(
          region: Aws.config[:region] || 'eu-central-1'
        )
      end

      def instance_name(tags)
        tag_value(tags, 'Name').split(' - ').last
      rescue
        'null'
      end

      def tag_value(tags, key)
        return nil if tags.empty?

        tag = tags.detect { |tag| tag.key == key }
        return tag.value if tag

        'null'
      end
    end
  end
end
