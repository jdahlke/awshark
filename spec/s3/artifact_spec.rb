# frozen_string_literal: true

RSpec.describe Awshark::S3::Artifact do
  let(:file) { Awshark::S3::Artifact.new(key) }

  shared_examples 'is fingerprinted' do
    it { expect(file.fingerprint?).to eq(true) }
  end

  shared_examples 'is not fingerprinted' do
    it { expect(file.fingerprint?).to eq(false) }
  end

  shared_examples 'has content type' do |mimetype|
    it { expect(file.content_type).to eq(mimetype) }
  end

  describe '#fingerprint?' do
    examples = {
      nil => false,
      '' => false,
      '/shark-20200312154716/build/index.js' => false,
      '/shark-20200312154716/build/vimeo_widget.6998f1c45d892fca1d57a35828161e50.svg' => true,
      '/assets/index.a252fb3e212f5cd734a7.js' => true
    }

    examples.each do |key, expected|
      context "with #{key.inspect}" do
        let(:key) { key }

        if expected
          include_examples 'is fingerprinted'
        else
          include_examples 'is not fingerprinted'
        end
      end
    end
  end

  describe '#content_type' do
    examples = {
      '' => 'application/octet-stream',
      'build/index.js' => 'application/javascript',
      'vimeo_widget.6998f1c45d892fca1d57a35828161e50.svg' => 'image/svg+xml',
      'foo/bar.jpg' => 'image/jpeg',
      'foo/bar.jpg.pdf' => 'application/pdf'
    }

    examples.each do |key, content_type|
      context "with #{key.inspect}" do
        let(:key) { key }

        include_examples 'has content type', content_type
      end
    end
  end
end
