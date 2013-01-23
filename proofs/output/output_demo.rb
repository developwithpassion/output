require_relative '../proofs_init'

class SomeOutput
  include Output
  include Single
  include Setter::Settings

  level :info

  writer :debug, :level => :debug
  writer :info, :level => :info
  writer :warn, :level => :warn
  writer :error, :level => :error
  writer :fatal, :level => :fatal
end

title "Output Demo"

level = SomeOutput.instance.level

section "Logging level: #{level}" do
  SomeOutput.debug "Debug @ #{level}"
  SomeOutput.info "Info @ #{level}"
  SomeOutput.warn "Warn @ #{level}"
  SomeOutput.error "Error @ #{level}"
  SomeOutput.fatal "Fatal @ #{level}"
end

SomeOutput.push_level :debug do
  level = SomeOutput.instance.level
  heading "Logging level: #{level}"
  SomeOutput.debug "Debug @ #{level}"
end
