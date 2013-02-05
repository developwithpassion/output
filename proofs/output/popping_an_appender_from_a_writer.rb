require_relative '../proofs_init'

title 'Popping An Appender From A Writer'

module Output
  class Writer
    module Proof
      def appender?(appender)
        appenders.include?(appender) &&
          @logger.appenders.include?(appender)
      end
      def logger_appender?(appender)
        @logger.appenders.include?(appender)
      end
    end
  end
end

def new_appender
  Logging.appenders.string_io(:something)
end

def new_writer
  logger = Logging::logger['Something']
  logger.level = :debug

  Output::Writer.new 'first',:debug, nil, logger
end


proof 'Removes it from the list of appenders' do
  appender = new_appender
  writer = new_writer
  writer.push_appender appender

  writer.pop_appender

  writer.prove { not appender? appender }
end

proof 'Removes it from its logger' do
  appender = new_appender
  writer = new_writer
  writer.push_appender appender

  writer.pop_appender

  writer.prove { not logger_appender? appender }
end
