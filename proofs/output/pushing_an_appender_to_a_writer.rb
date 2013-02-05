require_relative '../proofs_init'

title 'Pushing An Appender To A Writer'

module Output
  class Writer
    module Proof
      def appender?(appender)
        appenders.include?(appender)
      end

      def logger_appender?(appender)
        @logger.appenders.include?(appender)
      end

      def appenders?(appender, occurences)
        appenders.include?(appender) &&
          appenders.count == occurences
      end

      def logger_appenders?(appender, occurences)
        @logger.appenders.include?(appender) &&
          @logger.appenders.select{|item| item == appender}.count == occurences
      end
    end
  end
end

def new_appender
  Logging.appenders.string_io(:first)
end

def new_writer
  logger = Logging::logger['First']
  logger.level = :debug

  Output::Writer.new 'first',:debug, nil, logger
end

heading 'Pushing an appender' do
  appender = new_appender

  proof 'Appender is added to list of appenders' do
    writer = new_writer

    writer.push_appender appender

    writer.prove { appender? appender }
  end
  proof 'Appender is added to its loggers appenders' do
    writer = new_writer

    writer.push_appender appender

    writer.prove { logger_appender? appender }
  end
end

heading 'Pushing an appender that the writer already has' do
  appender = new_appender

  proof 'Appender is not re-added to its list of appenders' do
    writer = new_writer

    writer.push_appender appender
    writer.push_appender appender

    writer.prove { appenders? appender, count = 1 }

  end

  proof 'Appender is not re-added to its loggers appenders' do
    writer = new_writer

    writer.push_appender appender
    writer.push_appender appender

    writer.prove { logger_appenders? appender, count = 1 }

  end
end

heading 'Pushing an appender with a block' do
  appender = new_appender

  proof 'Appender is added to list of appenders' do
    writer = new_writer

    writer.push_appender appender do
      writer.prove { appender? appender }
    end
  end
  proof 'Appender is added to its loggers appenders' do
    writer = new_writer

    writer.push_appender appender do
      writer.prove { logger_appender? appender }
    end
  end

  proof 'Appender is removed from its list of appenders after running the block' do
    writer = new_writer

    writer.push_appender appender do
    end
    writer.prove { !appender? appender }
  end

  proof 'Appender is removed from its loggers appenders after running the block' do
    writer = new_writer

    writer.push_appender appender do
    end
    writer.prove { !logger_appender? appender }
  end
end

