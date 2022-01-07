# frozen_string_literal: true

require 'awshark'

require 'support/mocks'

Awshark.logger.level = Logger::WARN

RSpec.configure do |config|
  config.before(:suite) do
    Mocks.stub_aws
  end

  config.after(:suite) do
    Mocks.unstub_aws
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
