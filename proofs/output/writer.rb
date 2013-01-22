require_relative '../proofs_init'

module Output
  class Writer
    module Proof
      def written?(message)
        logger.appenders.first.sio.to_s.include? message
      end
    end
  end
end

def writer
  logger = Logging.logger['info']

  layout = Logging.layouts.pattern(:pattern => '%m\n')
  appender = Logging::Appenders::StringIo.new('string_io', :layout => layout)

  logger.appenders = appender

  writer = Output::Writer.new logger, :info
  writer.extend Output::Writer::Proof

  writer
end

w = writer
w.write 'some message'

# TODO use proof once we fix it
raise unless w.written? 'some message'
