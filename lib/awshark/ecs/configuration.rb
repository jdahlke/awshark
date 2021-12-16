# frozen_string_literal: true

module Awshark
  module Ecs
    class Configuration
      def client
        @client ||= begin
                      region = Aws.config[:region]
                      Aws::ECS::Client.new(region: region)
                    end
      end

      attr_writer :client
    end
  end
end
