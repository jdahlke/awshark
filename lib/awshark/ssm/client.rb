# frozen_string_literal: true

module Awshark
  module Ssm
    class Client
      def list_secrets(application:)
        response = client.get_parameters_by_path({
                                                   path: application,
                                                   recursive: true,
                                                   with_decryption: true
                                                 })
        response.parameters
      end

      def update_secrets(application:, secrets:)
        flat_secrets = flatten_hash(secrets)

        flat_secrets.each_pair do |key, value|
          params = {
            name: "/#{application}/#{key.downcase}",
            value: value,
            type: 'SecureString', # accepts String, StringList, SecureString
            tier: 'Standard' # accepts Standard, Advanced, Intelligent-Tiering
          }

          loop do
            client.put_parameter(params.merge(overwrite: true))
            puts "Updated secrets for: #{params[:name]}"

            break
          rescue Aws::SSM::Errors::ThrottlingException
            puts 'Aws::SSM::Errors::ThrottlingException... retrying'
            sleep 1
          end
        end
      end

      private

      def client
        @client ||= Aws::SSM::Client.new
      end

      # helper function
      def flatten_hash(hash, prefix = nil)
        hash.each_with_object({}) do |(key, value), rslt|
          if value.is_a?(Hash)
            rslt.merge!(flatten_hash(value, "#{prefix}#{key}_"))
          else
            rslt["#{prefix}#{key}"] = value
          end
        end
      end
    end
  end
end
