# frozen_string_literal: true

module Mocks
  def self.stub_aws
    Awshark.config.send(:sts_client=, Aws::STS::Client.new(stub_responses: true))
    stub_cloudformation
  end

  def self.unstub_aws
    Awshark.config.send(:sts_client=, nil)
    unstub_cloudformation
  end

  def self.stub_cloudformation
    client = Aws::CloudFormation::Client.new(
      region: 'us-east-1',
      stub_responses: true
    )

    Awshark.config.cloud_formation.client = client
  end

  def self.unstub_cloudformation
    Awshark.config.cloud_formation.client = nil
  end
end
