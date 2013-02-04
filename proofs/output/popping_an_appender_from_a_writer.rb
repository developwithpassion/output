require_relative '../proofs_init'

title 'Popping An Appender From A Writer'

module Output
  class Writer
    module Proof
      def appender?(appender)
        extra_appenders.include?(appender) &&
          @logger.appenders.include?(appender)
      end
      def logger_appender?(appender)
        @logger.appenders.include?(appender)
      end
    end
  end
end

def new_writer
  logger = Logging::logger['First']
  logger.level = :debug

  Output::Writer.new 'first',:debug, nil, logger
end

proof 'Removes it from the list of extra appenders' do
  appender = Logging.appenders.file('output.log')
  writer = new_writer
  writer.push_appender appender

  writer.pop_appender

  writer.prove { not appender? appender }
end

proof 'Removes it from its loggers list of appenders' do
  appender = Logging.appenders.file('output.log')
  writer = new_writer
  writer.push_appender appender

  writer.pop_appender

  writer.prove { not logger_appender? appender }
end
