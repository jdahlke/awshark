# frozen_string_literal: true

module Awshark
  module Sts
    class Configuration
      def aws_account_id
        @aws_account_id ||= begin
                              response = client.get_caller_identity
                              response.account
                            end
      end

      def client
        @client ||= Aws::STS::Client.new
      end

      attr_writer :client
    end
  end
end
