# frozen_string_literal: true

RSpec.describe Awshark::CloudFormation::FileLoader do
  let(:loader) { described_class.new(path) }

  describe '#template' do
    %i[yaml json].each do |type|
      context "type=#{type}" do
        context 'with directory path is directory' do
          let(:path) { "spec/fixtures/cloud_formation/#{type}" }

          it 'returns parsed file as Hash' do
            expect(loader.template).to be_a(Hash)
          end
        end

        context 'with file path' do
          let(:path) { "spec/fixtures/cloud_formation/#{type}/template.#{type}" }

          it { expect(loader.template).to be_a(Hash) }
        end
      end
    end
  end

  describe '#parameters' do
    %i[yaml json].each do |type|
      context "type=#{type}" do
        context 'with directory path is directory' do
          let(:path) { "spec/fixtures/cloud_formation/#{type}" }

          it { expect(loader.parameters).to be_a(Hash) }
        end

        context 'with file path' do
          let(:path) { "spec/fixtures/cloud_formation/#{type}/template.#{type}" }

          it { expect(loader.parameters).to eq({}) }
        end
      end
    end

    context 'with no file' do
      let(:path) { "spec/fixtures/cloud_formation/empty" }

      it { expect(loader.parameters).to eq({}) }
    end
  end
end
