require_relative '../proofs_init'
require_relative 'examples'

module Logging
  module Appenders
    class StringIo
      def contains?(message)
        @content ||= read
        /#{message}/.match @content
      end
    end
  end
end

def create_writer_with_string_appender
  appender = Examples::WriterBuilder.create_string_appender
  writer = Examples::WriterBuilder.create_writer 'example', appender

  return writer, appender
end

proof 'Output only gets written when the writer is enabled' do
  writer, appender  = create_writer_with_string_appender

  writer.write :info, 'Hello'

  writer.disable
  writer.write :info, 'Not Displayed'

  writer.enable
  writer.write :info, 'Again'

  appender.prove { contains? 'Hello' }
  appender.prove { not contains? 'Not Displayed' }
  appender.prove { contains? 'Again' }
end
