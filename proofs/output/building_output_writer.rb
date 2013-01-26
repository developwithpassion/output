require_relative '../proofs_init'

title "Building a Writer on an Output"

heading "Writer's logger level is set to the Output object's level when the writer is built"

module AssignWriter
  class Output
    include ::Output

    level :info

    writer :something, :level => :debug
  end
end

module Output
  class Writer
    module Proof
      def level?(level)
        logger_level == level
      end
    end
  end
end

def output
  AssignWriter::Output.new
end

proof "Writer's logger level is the output's level" do
  output.level = :debug
  writer = output.build_writer :something, :fatal
  writer.prove { level? output.level }
end
