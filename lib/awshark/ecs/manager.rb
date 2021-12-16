# frozen_string_literal: true

module Awshark
  module Ecs
    class Manager
      def clusters
        response = client.list_clusters
        response.cluster_arns.map { |arn| Ecs::Cluster.new(arn) }
      end

      def inspect_cluster(cluster)
        args = { name: cluster.name, services: cluster.services.size, tasks: cluster.tasks.size }
        format("Cluster: %-20<name>s %<services>s services %<tasks>s tasks\n", args)
      end

      # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/ECS/Types/Container.html
      #
      # @param task [Aws::ECS::Types::Container]
      def inspect_container(container)
        args = { name: container.name, health: container.health_status, status: container.last_status }
        format("- %-15<name>s status: %<status>s\n", args)
      end

      # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/ECS/Types/Service.html
      #
      # @param task [Aws::ECS::Types::Service]
      def inspect_service(service)
        task = task_definition(service.task_definition)
        lines = []

        args = {
          name: service.service_name,
          status: service.status,
          running: service.running_count,
          cpu: "#{task.cpu}MB",
          memory: "#{task.memory}MB"
        }
        lines << format('Service: %-30<name>s status: %-8<status>s running: %-4<running>s ' \
                        "cpu: %-8<cpu>s mem: %<memory>s\n", args)
        task.container_definitions.each do |c|
          lines << format("- %-15<name>s\n", name: c.name)
        end

        lines.join
      end

      # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/ECS/Types/Task.html
      #
      # @param task [Aws::ECS::Types::Task]
      def inspect_task(task)
        lines = []

        args = { type: task.launch_type, cpu: "#{task.cpu} MB", memory: "#{task.memory} MB" }
        lines << format("Task: %-20<type>s cpu: %-10<cpu>s memory: %<memory>s\n", args)

        task.containers.each { |c| lines << inspect_container(c) }

        lines.join
      end

      def task_definition(family)
        response = client.describe_task_definition(task_definition: family)
        response.task_definition
      end

      private

      def client
        Awshark.config.ecs.client
      end
    end
  end
end
