require_relative '../proofs_init'

title 'Pushing An Appender To A Writer'

module Output
  class Writer
    module Proof
      def appender?(appender)
        extra_appenders.include?(appender)
      end

      def logger_appender?(appender)
        @logger.appenders.include?(appender)
      end

      def appenders?(appender, occurences)
        extra_appenders.include?(appender) &&
          extra_appenders.count == occurences
      end

      def logger_appenders?(appender, occurences)
        @logger.appenders.include?(appender) &&
          @logger.appenders.select{|item| item == appender}.count == occurences
      end
    end
  end
end

def new_writer
  logger = Logging::logger['First']
  logger.level = :debug

  Output::Writer.new 'first',:debug, nil, logger
end

heading 'Pushing an appender' do
  proof 'Appender is added to list of extra appenders' do
    appender = Logging.appenders.file('output.log')
    writer = new_writer

    writer.push_appender appender

    writer.prove { appender? appender }
  end
  proof 'Appender is added to its loggers appenders' do
    appender = Logging.appenders.file('output.log')
    writer = new_writer

    writer.push_appender appender

    writer.prove { logger_appender? appender }
  end
end

heading 'Pushing an appender that the writer already has' do
  proof 'Appender is not re-added to its list of extra appenders' do
    appender = Logging.appenders.file('second.log')
    writer = new_writer

    writer.push_appender appender
    writer.push_appender appender

    writer.prove { appenders? appender, 1 }

  end

  proof 'Appender is not re-added to its loggers appenders' do
    appender = Logging.appenders.file('second.log')
    writer = new_writer

    writer.push_appender appender
    writer.push_appender appender

    writer.prove { logger_appenders? appender, 1 }

  end
end

