# frozen_string_literal: true

RSpec.describe Awshark::CloudFormation::Manager do
  let(:path) { 'spec/fixtures/cloud_formation/yaml' }
  let(:stage) { 'test' }
  let(:manager) { described_class.new(path, stage: stage, bucket: 'foobar') }

  describe '#stack' do
    it 'return CloudFormation::Stack' do
      expected_class = Awshark::CloudFormation::Stack
      expect(manager.stack).to be_kind_of(expected_class)
    end
  end

  describe '#diff_stack_template' do
    it 'returns String' do
      expect(manager.diff_stack_template).to be_kind_of(String)
    end
  end

  describe '#update_stack' do
    it 'does not raise error' do
      expect { manager.update_stack }.to_not raise_error
    end
  end
end
