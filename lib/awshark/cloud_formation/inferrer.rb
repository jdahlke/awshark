# frozen_string_literal: true

#
# https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/CloudFormation/Client.html
#
module Awshark
  module CloudFormation
    class Inferrer
      attr_reader :path, :stage

      def initialize(path, stage = nil)
        @path = path
        @stage = stage
      end

      def stack_name
        file_extension = File.extname(path)
        name = File.basename(path, file_extension)

        [name, stage].compact.join('-').gsub('_', '-')
      end
    end
  end
end
