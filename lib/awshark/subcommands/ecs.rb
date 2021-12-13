# frozen_string_literal: true

require 'aws-sdk-ecr'
require 'aws-sdk-ecs'

require 'awshark/ecs/cluster'
require 'awshark/ecs/manager'

module Awshark
  module Subcommands
    class Ecs < Thor
      include Awshark::Subcommands::ClassOptions

      desc 'list', 'list ECS tasks'
      long_desc <<-LONGDESC
        List all running ECS tasks and services.

        Example: `awshark ecs list`
      LONGDESC
      def list
        manager = Awshark::Ecs::Manager.new
        manager.clusters.each do |cluster|
          puts "\n"
          puts manager.inspect_cluster(cluster)
          cluster.services.each do |service|
            puts manager.inspect_service(service)
          end
        end
      end

      desc 'login', 'docker login to AWS ECR'
      long_desc <<-LONGDESC
        Use docker login with AWS credentials to Elastic Container Registry

        Example: `awshark ecs login`
      LONGDESC
      def login
        response = client.get_authorization_token
        token = Base64.decode64(response.authorization_data.first.authorization_token)

        user_name = token.split(':').first
        password = token.split(':').last
        url = "https://#{Awshark.config.aws_account_id}.dkr.ecr.eu-central-1.amazonaws.com"

        `docker login -u #{user_name} -p #{password} #{url}`
      end

      private

      def client
        @client ||= Aws::ECR::Client.new(region: region)
      end

      def region
        Aws.config[:region] || 'eu-central-1'
      end
    end
  end
end
