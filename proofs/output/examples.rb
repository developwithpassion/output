require_relative '../proofs_init'

class WriterBuilder
  def self.create_string_appender
    layout = Logging.layouts.pattern(:pattern => '%m\n')
    string_appender = Logging::Appenders::StringIo.new('string', :layout => layout)

    string_appender
  end

  def self.create_writer(name, appender)

    logger = Logging.logger[name]
    logger.appenders = appender
    logger.level = :debug

    writer = ::Output::Writer.new logger, :debug
    writer
  end
end

class AppOutput
  include Output::OutputBase

  writer :message, :level => :info

  writer :formatted_message, :level => :debug do|message|
    "Formatted Message: #{message}"
  end
end

def initialize_writers(appender)
  AppOutput.message_logger = WriterBuilder.create_writer 'Example1::First', appender
  AppOutput.formatted_message_logger = WriterBuilder.create_writer 'Example1::Second', appender
end


##Write some messages using the output mechanism

proof 'Outputs log messages' do
  appender = WriterBuilder.create_string_appender
  initialize_writers appender

  AppOutput.message 'Hello'
  AppOutput.formatted_message 'Hello'

  appender.prove { /Hello/ =~ readlines.join("\n") }
end
