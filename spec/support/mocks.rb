# frozen_string_literal: true

module Mocks
  def self.stub_aws
    # Cloud Formation
    client = Aws::CloudFormation::Client.new(region: 'us-east-1', stub_responses: true)
    Awshark.config.cloud_formation.client = client

    # ECS
    client = Aws::ECS::Client.new(region: 'us-east-1', stub_responses: true)
    Awshark.config.ecs.client = client

    # S3
    client = Aws::S3::Client.new(region: 'us-east-1', stub_responses: true)
    Awshark.config.s3.client = client

    # STS
    Awshark.config.sts.client = Aws::STS::Client.new(stub_responses: true)
  end

  def self.unstub_aws
    Awshark.config.cloud_formation.client = nil
    Awshark.config.ecs.client = nil
    Awshark.config.s3.client = nil
    Awshark.config.sts.client = nil
  end
end
