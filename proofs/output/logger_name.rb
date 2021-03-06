require_relative '../proofs_init'

title "Logger Name"

heading "Loggers are named for their full class name, including namespace, and can include an optional suffix"

module LoggerName
  class Output
    include ::Output

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

def something_writer
  output = LoggerName::Output.new
  output.something_writer
end

proof "Logger name is the fully-qualified name of the output class and the writer name" do
  something_writer.prove { logger_name? 'LoggerName::Output::Something' }
end
