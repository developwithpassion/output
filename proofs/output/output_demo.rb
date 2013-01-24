require_relative '../proofs_init'

title "Output Demo"

module OutputDemo
  class Output
    include ::Output
    include Single

    level :info

    writer :debug, :level => :debug
    writer :info, :level => :info
    writer :warn, :level => :warn
    writer :error, :level => :error
    writer :fatal, :level => :fatal
  end
end

level = OutputDemo::Output.instance.level

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
