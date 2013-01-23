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
