require_relative '../proofs_init'

class SomeOutput
  include Output
  include Single
  include Setter::Settings

  writer :message, :level => :info
end

SomeOutput.message "This writes a message to STDOUT"
