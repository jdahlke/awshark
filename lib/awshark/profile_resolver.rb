# frozen_string_literal: true

module Awshark
  class ProfileResolver
    attr_reader :region

    def initialize(options)
      @profile = options[:profile] || ENV['AWS_PROFILE']
      @shared_config = ::Aws::SharedConfig.new(
        profile_name: @profile,
        config_enabled: true
      )
      @region = options[:region] || @shared_config.region || 'eu-central-1'
    end

    def credentials
      user_credentials || role_credentials
    end

    # Returns Aws credentials for configuration with
    #  [profile]
    #  aws_access_key_id=AWS_ACCESS_KEY_ID
    #  aws_secret_access_key=AWS_SECRET_ACCESS_KEY
    #
    # Returns nil for configuration with
    #  [profile]
    #  role_arn = ROLE_ARN
    #  source_profile = SOURCE_PROFILE
    #
    # @returns [Aws::Credentials]
    def user_credentials
      @shared_config.credentials
    end

    # Returns Aws credentials for configuration with
    #  [profile]
    #  role_arn = ROLE_ARN
    #  source_profile = SOURCE_PROFILE
    #
    # @throws [Aws::STS::Errors::AccessDenied] if MultiFactorAuthentication failed
    # @returns [Aws::Credentials]
    def role_credentials
      @shared_config.assume_role_credentials_from_config(
        region: region,
        token_code: mfa_token
      )
    end

    def mfa_token
      print %(Please enter MFA token for AWS account #{@profile}: )
      $stdin.gets.strip
    end
  end
end
