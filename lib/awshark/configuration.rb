# frozen_string_literal: true

module Awshark
  class Configuration
    attr_accessor :cloud_formation, :ecs, :s3

    def initialize
      @cloud_formation = OpenStruct.new(
        client: nil,
        event_polling: 3
      )

      @ecs = OpenStruct.new(
        client: nil
      )

      @s3 = OpenStruct.new(
        client: nil
      )
    end

    def aws_account_id
      return @aws_account_id if defined?(@aws_account_id)

      response = sts_client.get_caller_identity

      @aws_account_id = response.account
    end

    def sts_client
      @sts_client ||= Aws::STS::Client.new
    end

    private

    attr_writer :sts_client
  end
end
