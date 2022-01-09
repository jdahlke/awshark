# frozen_string_literal: true

module Awshark
  module Ec2
    class SecurityRule
      attr_reader :ip_protocol, :ip_ranges, :from_port, :to_port

      def initialize(args)
        if args.is_a?(Aws::EC2::Types::IpPermission)
          @ip_protocol = args.ip_protocol
          @ip_ranges = args.ip_ranges
          @from_port = args.from_port
          @to_port = args.to_port
        else
          ip = args.fetch(:ip)
          description = args.fetch(:description)
          @ip_protocol = args.fetch(:ip_protocol, 'tcp')
          @ip_ranges = [OpenStruct.new({ cidr_ip: "#{ip}/32", description: description })]
          @from_port = args.fetch(:from_port)
          @to_port = args.fetch(:to_port)
        end
      end

      def cidr_ip
        ip_ranges[0].cidr_ip
      end

      def description
        ip_ranges[0].description
      end

      def to_hash
        {
          ip_protocol: ip_protocol,
          from_port: from_port,
          to_port: to_port,
          ip_ranges: ip_ranges.map(&:to_h)
        }
      end
    end
  end
end
