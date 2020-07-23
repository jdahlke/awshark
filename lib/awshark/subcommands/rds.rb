# frozen_string_literal: true

require 'aws-sdk-rds'

require 'awshark/rds/check_reservations'
require 'awshark/rds/manager'

module Awshark
  module Subcommands
    class Rds < Thor
      include Awshark::Subcommands::ClassOptions

      desc 'check', 'Check RDS reservations'
      long_desc <<-LONGDESC
        List all RDS instances in a region and check reserved instances

        Example: `awshark rds check`
      LONGDESC
      def check
        process_class_options

        puts "\n+++ Instances +++"
        list

        checks = manager.check_reservations
        pattern = "%-15s %-15s %-15s %-15s %s\n"
        puts "\n+++ Check +++"
        printf pattern, 'Reserved', 'Instances', 'Type', 'MultiAZ', 'Comment'
        checks.each do |c|
          comment = if c.reserved_count > c.instance_count
                      "#{c.reserved_count - c.instance_count} instances available"
                    elsif c.reserved_count < c.instance_count
                      "#{c.instance_count - c.reserved_count} instances too many!!!"
                    else
                      ''
                    end
          printf pattern, c.reserved_count, c.instance_count, c.type, c.multi_az, comment
        end
      end

      desc 'list', 'List all RDS instances'
      long_desc <<-LONGDESC
        List all RDS instances in a region

        Example: `awshark rds list`
      LONGDESC
      def list
        process_class_options

        instances = manager.instances
        instances = instances.sort_by(&:name)

        pattern = "%-30s %-15s %-20s %-10s %-10s %s\n"
        printf pattern, 'Name', 'Type', 'Engine (Version)', 'MultiAZ', 'Encrypted', 'State'
        instances.each do |i|
          printf pattern, i.name, i.type, "#{i.engine} (#{i.engine_version})", i.multi_az, i.encrypted, i.state
        end
      end

      desc 'reservations', 'List all RDS reservations'
      long_desc <<-LONGDESC
        List all RDS reservations in a region

        Example: `awshark rds reservations`
      LONGDESC
      def reservations
        process_class_options

        reservations = manager.reservations

        pattern = "%-30s %-26s %-30s %s\n"
        printf pattern, 'Reserved', 'Type', 'MultiAZ', 'Offering'
        reservations.each do |r|
          printf pattern, r.count, r.type, r.multi_az, r.offering_type
        end
      end

      private

      def manager
        @manager ||= Awshark::Rds::Manager.new
      end
    end
  end
end
