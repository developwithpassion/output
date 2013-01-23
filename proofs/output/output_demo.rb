require_relative '../proofs_init'
require_relative './some_output'

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
