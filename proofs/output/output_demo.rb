require_relative '../proofs_init'

class SomeOutput
  include Output::OutputBase
  include Single
  include Setter::Settings

  writer :message, :level => :info

  # TEMPORARY
  # WARNING: Not an exemplar. Not a pattern. Do not replicate.
  def self.build
    layout = Logging.layouts.pattern(:pattern => '%m\n')
    stdout_appender = Logging::Appenders::Stdout.new('stdout', :layout => layout)

    some_logger = Logging.logger 'some logger'
    some_logger.appenders = stdout_appender

    some_writer = Output::Writer.new(some_logger, :info)

    instance.message_writer = some_writer
    instance
  end
end

SomeOutput.build
SomeOutput.message "This writes a message to STDOUT"

