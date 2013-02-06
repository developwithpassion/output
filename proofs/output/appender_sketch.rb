require_relative '../proofs_init'


module Sketch
  class Output
    include Single
    include ::Output

    level :info
    device :file
    pattern '%m\n'

    writer :string_io, :level => :info, :appender => :string_io
    writer :stdout, :level => :info, :appender => :stdout
    writer :file, :level => :info, :filename => 'some_log.txt'
  end
end


def new_output
  Sketch::Output.new
end

output = new_output

output.string_io 'Hello String IO'
output.stdout 'Hello Std Out'
output.file 'Hello File'
output.file 'Hello again File'

appender = output.file_writer.push_appender_from_opts(:string_io) do
  output.file 'This should go to both appenders'
end
puts appender.read


# writer.push_appender(:string_io) # => pattern is defaulted to '%m\n'
# 
# #
# 
# writer.push_appender__obj
# writer.push_appender__spec
# 
# #
# 
# writer.push_appender appender
# writer.push_appender Outut::Appenders.string_io('%m\n')
# 
# writer.write 'foos'
# writer.pop_appender
# 
# 
# 
# 
# writer :foo, :level => :debug, :appender => :stdout, :pattern => '[%d] %-5l %c: %m\n'
# writer.push_appender(:string_io)
# 
