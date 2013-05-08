require_relative '../proofs_init'

module DevicesDemo
  class Output
    include Single
    include ::Output

    level :info

    device :file # Default device
    pattern '%m\n' # Default pattern

    # Define a writer that writes to string_io
    writer :string_io, :level => :info, :device => :string_io
    #
    # Define a writer that writes to stdout
    writer :stdout, :level => :info, :device => :stdout
    
    # Define a writer that writes to a rolling file named
    # some_log.txt
    writer :file, :level => :info, :filename => 'some_log.txt'
  end
end

def output
  DevicesDemo::Output.new
end

otp = output

# Write to the different writers
otp.string_io 'Hello String IO'
otp.stdout 'Hello Std Out'
otp.file 'Hello File'
otp.file 'Hello again File'

# Temporarily push a new string_io device to a writer
device = otp.file_writer.push_device_from_opts(:string_io) do
  otp.file 'This should go to both devices'
end
puts device.read


