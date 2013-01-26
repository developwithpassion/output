require_relative '../proofs_init'

title "Output"

module OutputProofs
  class Output
    include ::Output

    level :info

    writer :message, :level => :debug
  end
end

level = OutputProofs::Output.instance.level

section "Logging level: #{level}" do
  OutputDemo::Output.debug "Debug @ #{level}"
  OutputDemo::Output.info "Info @ #{level}"
  OutputDemo::Output.warn "Warn @ #{level}"
  OutputDemo::Output.error "Error @ #{level}"
  OutputDemo::Output.fatal "Fatal @ #{level}"
end

OutputDemo::Output.push_level :debug do
  level = OutputDemo::Output.instance.level
  heading "Logging level: #{level}"
  OutputDemo::Output.debug "Debug @ #{level}"
end
