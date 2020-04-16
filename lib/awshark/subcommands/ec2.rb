# frozen_string_literal: true

require 'aws-sdk-ec2'
require 'awshark/ec2/manager'

module Awshark
  module Subcommands
    class EC2 < Thor
      include Awshark::Subcommands::ClassOptions

      desc 'list', 'List all EC2 instances'
      long_desc <<-LONGDESC
        List all EC2 instances in a region

        Example: `awshark ec2 list STATE`
      LONGDESC
      def list(state = 'running')
        process_class_options

        instances = manager.public_send("#{state}_instances")
        instances = instances.sort_by(&:name)

        instances.each do |i|
          printf "%-40s %-12s %-60s %s\n", i.name, i.type, i.public_dns_name, i.state
        end
      end

      private

      def manager
        @manager ||= Awshark::EC2::Manager.new
      end
    end
  end
end
