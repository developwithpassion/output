require_relative '../proofs_init'

title 'Demo - Writers with different devices'
module DevicesDemo
  class Output
    include Single
    include ::Output

    level :info

    device :file # Default device
    pattern '%m\n' # Default pattern

    # Define a writer that writes to string_io
    writer :string_io, :level => :info, :device => :string_io

    # Define a writer that writes to stdout
    writer :stdout, :level => :info, :device => :stdout
    
    # Define a writer that writes to a rolling file named
    # some_log.txt
    writer :file, :level => :info, :filename => 'some_log.log'

    # Define a writer that writes to stderr
    writer :error, :level => :info, :device => :stderr
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
otp.error 'An error message'

# Temporarily push a new string_io device to a writer, which will cause all writing to the writer to go to both devices
device = otp.file_writer.push_device(:string_io) do
  otp.file 'This should go to both devices'
end
puts device.read

File.delete('some_log.log') if File.exist?('some_log.log')
