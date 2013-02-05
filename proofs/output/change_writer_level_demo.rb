require_relative '../proofs_init'

title "Change Writer Level"

log_level_docs = <<-docs
  Log Levels:
  -----------
  * Fatal shows messages at a FATAL level only
  * Error shows messages classified as ERROR and FATAL
  * Warning shows messages classified as WARNING, ERROR, and FATAL
  * Info shows messages classified as INFO, WARNING, ERROR, and FATAL
  * Debug shows messages classified as DEBUG, INFO, WARNING, ERROR, and FATAL
docs

heading log_level_docs

module ChangeWriterLevelDemo
  class Output
    include ::Output

    level :info

    writer :something, :level => :debug

    module Proof
      def writes?(message)
        something message
        true
      end
    end
  end
end

def output
  ChangeWriterLevelDemo::Output.new
end
alias :new_output :output

heading "Writers write when the output object's level is inclusive of the writer's level"

proof "Writer doesn't write when it's level is lower than the output's level" do
  output.prove { writes? "\> This doesn't write because the writer is :debug and the logger is :info" }
end

proof "Writer writes when it's level is equal or greater than the output's level" do
  output = new_output
  output.level = :debug
  output.prove { writes? "\> This writes because the writer is :debug and the logger is :debug" }
end
