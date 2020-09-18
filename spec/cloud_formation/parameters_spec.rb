# frozen_string_literal: true

RSpec.describe Awshark::CloudFormation::Parameters do
  let(:parameters) { described_class.new(path: path, stage: stage) }
  let(:stage) { nil }

  json_path = 'spec/fixtures/cloud_formation/json'
  yaml_path = 'spec/fixtures/cloud_formation/yaml'

  describe '#to_hash' do
    subject { parameters.to_hash }

    context "with directory path #{json_path}" do
      let(:path) { json_path }

      it do
        is_expected.to eq({
          'HashKeyElementName' => 'foo',
          'HashKeyElementType' => 'N',
          'ReadCapacityUnits' => 1,
          'WriteCapacityUnits' => 1
        })
      end
    end

    context "with directory path #{yaml_path}" do
      let(:path) { yaml_path }
      let(:stage) { 'test' }

      it do
        is_expected.to eq({ 'AlarmEMail' => 'foo@example.com' })
      end
    end

    context 'with file path' do
      let(:path) { 'spec/fixtures/cloud_formation/yaml/template.yml' }

      it { is_expected.to eq({}) }
    end

    context 'with no parameters file' do
      let(:path) { "spec/fixtures/cloud_formation/empty" }

      it { is_expected.to eq({}) }
    end
  end

  describe '#stack_parameters' do
    subject { parameters.stack_parameters }

    context "with directory path #{json_path}" do
      let(:path) { json_path }

      it do
        is_expected.to eq([
          { parameter_key: 'HashKeyElementName', parameter_value: 'foo' },
          { parameter_key: 'HashKeyElementType', parameter_value: 'N' },
          { parameter_key: 'ReadCapacityUnits', parameter_value: 1 },
          { parameter_key: 'WriteCapacityUnits', parameter_value: 1 }
        ])
      end
    end

    context "with directory path #{yaml_path}" do
      let(:path) { yaml_path }
      let(:stage) { 'test' }

      it do
        is_expected.to eq([
          { parameter_key: 'AlarmEMail', parameter_value: 'foo@example.com' }
        ])
      end
    end

    context 'with file path' do
      let(:path) { 'spec/fixtures/cloud_formation/yaml/template.yml' }

      it { is_expected.to eq([]) }
    end

    context 'with no file' do
      let(:path) { 'spec/fixtures/cloud_formation/empty' }

      it { is_expected.to eq([]) }
    end
  end
end
