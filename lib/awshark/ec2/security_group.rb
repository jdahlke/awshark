# frozen_string_literal: true

module Awshark
  module Ec2
    class SecurityGroup
      include Logging

      attr_reader :security_group_id, :username

      def initialize(id:, username:)
        validate!(:id, id)
        validate!(:username, username)

        @security_group_id = id
        @username = username
      end

      def authorize(ip:, ports:)
        ports.each do |port|
          ip_rule = SecurityRule.new(
            ip: ip,
            from_port: port,
            to_port: port,
            description: username
          )
          client.authorize_security_group_ingress(
            group_id: security_group_id,
            ip_permissions: [ip_rule.to_hash]
          )
          logger.info "Created ingress rule in for #{ip_rule.cidr_ip}, port #{port}."
        rescue Aws::EC2::Errors::InvalidPermissionDuplicate
          logger.warn "An ingress rule for #{ip} and port #{port} exists."
        end
      end

      def unauthorize
        return if my_ingress_rules.empty?

        client.revoke_security_group_ingress(
          group_id: security_group_id,
          ip_permissions: my_ingress_rules
        )
        logger.info "Removed all ingress rules for #{username}."
      end

      def my_ingress_rules
        return @my_ingress_rules if defined?(@my_ingress_rules)

        response = client.describe_security_groups(group_ids: [security_group_id])
        return [] if response.security_groups.empty?

        security_group = response.security_groups.first
        security_rules = security_group.ip_permissions.map do |ip_permission|
          SecurityRule.new(ip_permission)
        end

        @my_ingress_rules = security_rules.map do |rule|
          rule.ip_ranges.keep_if { |ip_range| ip_range.description == username }
          rule.ip_ranges.any? ? rule.to_hash : nil
        end

        @my_ingress_rules.compact!
      end

      private

      def client
        Awshark.config.ec2.client
      end

      def validate!(name, value)
        raise ArgumentError, "Argument #{name} cannot be empty" if value.blank?
      end
    end
  end
end
