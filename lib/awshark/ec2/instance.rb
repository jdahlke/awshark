# frozen_string_literal: true

module Awshark
  module EC2
    class Instance
      attr_reader :id
      attr_reader :type
      attr_reader :state
      attr_reader :private_ip_address
      attr_reader :public_ip_address
      attr_reader :public_dns_name
      attr_reader :vpc_id
      attr_reader :subnet_id
      attr_reader :tags

      def initialize(instance)
        @id = instance.instance_id
        @type = instance.instance_type
        @state = instance.state.name
        @private_ip_address = instance.private_ip_address
        @public_ip_address = instance.public_ip_address
        @public_dns_name = instance.public_dns_name
        @vpc_id = instance.vpc_id
        @subnet_id = instance.subnet_id
        @tags = instance.tags
      end

      def name
        tag_value(tags, 'Name').split(' - ').last
      rescue StandardError
        'null'
      end

      private

      def tag_value(tags, key)
        return nil if tags.empty?

        tag = tags.detect { |t| t.key == key }
        return tag.value if tag

        'null'
      end
    end
  end
end
