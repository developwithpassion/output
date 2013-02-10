require_relative '../proofs_init'
require_relative '../example/builders'

include OutputProofs

title 'Displaying Output Details'

module DisplayingOutputDetails
  class Output
    include ::Output

    device :string_io

    writer :first_writer
    writer :second_writer
  end
end

def device
  Builders.device
end

def output
  DisplayingOutputDetails::Output.new
end

proof do
  otp = output
  dvc = Builders.device
  logger_device = Builders.device(:stdout, :name => :another_name)
  otp.push_device dvc 

  result = otp.to_s

  desc 'Includes the name'
  result.prove { include? otp.class.name }

  desc 'Includes the level'
  result.prove { include? otp.level.to_s }

  puts result
end
