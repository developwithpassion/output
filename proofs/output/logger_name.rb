require_relative '../proofs_init'

title "Logger Name"

heading "Loggers are named for their full class name, including namespace, and can include an optional suffix"

module LoggerName
  class Output
    include ::Output
    include Single

    writer :something
  end
end

module Output
  class Writer
    module Proof
      def logger_name?(val)
        logger_name == val
      end
    end
  end
end

output = LoggerName::Output.instance
something_writer = output.something_writer

proof "Logger name is the fully-qualified name of the output class and the writer name" do
  logger_name = output.something_writer.logger_name
  something_writer.prove { logger_name? 'LoggerName::Output::Something' }
end
