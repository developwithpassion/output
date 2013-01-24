require_relative '../proofs_init'

title "Change Writer Level Demo"

log_level_docs = <<-docs
  Log Levels:
  -----------
  * Fatal: shows messages at a FATAL level only
  * Error: Shows messages classified as ERROR and FATAL
  * Warning: Shows messages classified as WARNING, ERROR, and FATAL
  * Info: Shows messages classified as INFO, WARNING, ERROR, and FATAL
  * Debug: Shows messages classified as DEBUG, INFO, WARNING, ERROR, and FATAL
docs

heading log_level_docs

heading "Writers write when the output object's level is inclusive of the writer's level" do
  comment "TODO Proofs can be written once the Proof library output object uses a StringIo appender"
end

module ChangeWriterLevel
  class Output
    include ::Output
    include Single

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

output = ChangeWriterLevel::Output.instance

proof "Writer doesn't write when it's level is lower than the output's level" do
  output.prove { writes? "\> This doesn't write because the writer is :debug and the logger is :info" }
end

proof "Writer writes when it's level is equal or greater than the output's level" do
  output.level = :debug
  output.prove { writes? "\> This writes because the writer is :debug and the logger is :debug" }
end
