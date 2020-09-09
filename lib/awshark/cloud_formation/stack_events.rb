# frozen_string_literal: true

module Awshark
  module CloudFormation
    class StackEvents
      attr_reader :stack
      attr_reader :start_time, :last_event

      def initialize(stack)
        @stack = stack
        @start_time = Time.now - 10
      end

      def done?
        return false if last_event.nil?
        return false if last_event.resource_type != 'AWS::CloudFormation::Stack'

        last_event.resource_status.match(/IN_PROGRESS/).nil?
      end

      def new_events
        events = stack.events

        return [] if events.blank?

        if last_event.nil?
          @last_event = events.first
          new_events = events.select { |e| e.timestamp > start_time }
          return new_events
        end

        return [] unless new_events?(events)

        last_event_index = events.index { |e| e.event_id == last_event.event_id }
        new_events = events[0..last_event_index - 1]
        @last_event = new_events.first

        new_events
      end

      def new_events?(events)
        events.first.event_id != last_event.event_id
      end
    end
  end
end
