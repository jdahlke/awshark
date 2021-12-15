# frozen_string_literal: true

module Awshark
  module Ecs
    class Cluster
      attr_reader :arn

      def initialize(arn)
        @arn = arn
      end

      def name
        arn.split('/').last
      end

      def tasks
        @tasks ||= begin
                     response = client.list_tasks(cluster: arn)
                     response = client.describe_tasks(cluster: arn, tasks: response.task_arns)
                     response.tasks
                   end
      end

      def services
        @services ||= begin
                        response = client.list_services(cluster: arn)
                        response = client.describe_services(cluster: arn, services: response.service_arns)
                        response.services
                      end
      end

      private

      def client
        return Awshark.config.ecs.client if Awshark.config.ecs.client

        region = Aws.config[:region] || 'eu-central-1'
        @client ||= Aws::ECS::Client.new(region: region)
      end
    end
  end
end
