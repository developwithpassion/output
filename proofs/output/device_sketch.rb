require_relative '../proofs_init'


module Sketch
  class Output
    include Single
    include ::Output

    level :info
    device :file
    pattern '%m\n'

    writer :string_io, :level => :info, :device => :string_io
    writer :stdout, :level => :info, :device => :stdout
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

device = output.file_writer.push_device_from_opts(:string_io) do
  output.file 'This should go to both devices'
end
puts device.read


# writer.push_device(:string_io) # => pattern is defaulted to '%m\n'
# 
# #
# 
# writer.push_device__obj
# writer.push_device__spec
# 
# #
# 
# writer.push_device device
# writer.push_device Outut::Devices.string_io('%m\n')
# 
# writer.write 'foos'
# writer.pop_device
# 
# 
# 
# 
# writer :foo, :level => :debug, :device => :stdout, :pattern => '[%d] %-5l %c: %m\n'
# writer.push_device(:string_io)
# 
