# frozen_string_literal: true

module Mocks
  def self.stub_aws
    Awshark.config.send(:sts_client=, Aws::STS::Client.new(stub_responses: true))
    CloudFormation.stub
    S3.stub
  end

  def self.unstub_aws
    Awshark.config.send(:sts_client=, nil)
    CloudFormation.unstub
    S3.unstub
  end

  module CloudFormation
    def self.stub
      client = Aws::CloudFormation::Client.new(region: 'us-east-1', stub_responses: true)
      Awshark.config.cloud_formation.client = client
    end

    def self.unstub
      Awshark.config.cloud_formation.client = nil
    end
  end

  module S3
    def self.stub
      client = Aws::S3::Client.new(region: 'us-east-1', stub_responses: true)
      Awshark.config.s3.client = client
    end

    def self.unstub
      Awshark.config.s3.client = nil
    end
  end
end
