# frozen_string_literal: true

require 'aws-sdk-ec2'

require 'awshark/ec2/instance'
require 'awshark/ec2/manager'
require 'awshark/ec2/security_group'
require 'awshark/ec2/security_rule'

module Awshark
  module Ec2
    class Subcommand < Thor
      include Awshark::ClassOptions

      desc 'list', 'List all EC2 instances'
      long_desc <<-LONGDESC
        List all EC2 instances in a region

        Example:
          awshark ec2 list STATE

      LONGDESC
      def list(state = 'running')
        process_class_options

        instances = manager.public_send("#{state}_instances")
        instances = instances.sort_by(&:name)

        instances.each do |i|
          args = { name: i.name, type: i.type, public_dns: i.public_dns_name, state: i.state }
          printf "%-40<name>s %-12<type>s %-60<public_dns>s %<state>s\n", args
        end
      end

      desc 'authorize', 'Authorises your IP to access AWS'
      long_desc <<-LONGDESC
        Adds your IP address to the security group to allow direct access to the VPCs.

        Example:
          awshark ec2 authorize

      LONGDESC
      option :ports,
             type: :string,
             desc: 'Ports to register. Only uses ports from 1 to 65535.',
             default: '443'
      option :security_group,
             type: :string,
             required: true,
             desc: 'Security group to allow access to.'
      option :username,
             type: :string,
             desc: 'Ports to register. Only uses ports from 1 to 65535.'
      def authorize
        process_class_options

        group = Ec2::SecurityGroup.new(id: security_group_id, username: username)
        group.authorize(ip: my_ip, ports: ports)
      end

      desc 'unauthorize', 'Removes your IP from access to AWS'
      long_desc <<-LONGDESC
        Removes all your ingress rules from the home office security group in the VPCs.

        Example:
          awshark ec2 unauthorize

      LONGDESC
      option :security_group,
             type: :string,
             required: true,
             desc: 'Security group to remove access from.'
      option :username,
             type: :string,
             desc: 'Ports to register. Only uses ports from 1 to 65535.'
      def unauthorize
        process_class_options

        group = Ec2::SecurityGroup.new(id: security_group_id, username: username)
        group.unauthorize
      end

      private

      def manager
        @manager ||= Ec2::Manager.new
      end

      def my_ip
        @my_ip ||= `curl -s https://api.ipify.org`.strip
      end

      def ports
        result = options[:ports].split(',').map(&:to_i)
        result.select { |port| (1..65_535).cover?(port) }
      end

      def security_group_id
        options[:security_group].strip
      end

      def username
        options[:username].presence || `whoami`.strip
      end
    end
  end
end
