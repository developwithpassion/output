require_relative '../proofs_init'
require_relative '../example/builders'

include OutputProofs

title 'Displaying Writer Details'

def writer
  Builders.writer
end

proof do
  wrt = writer
  dvc = Builders.device
  logger_device = Builders.device(:stdout, :name => :another_name)
  wrt.push_device dvc 
  wrt.add_device logger_device

  result = wrt.to_s

  desc 'Includes the name'
  result.prove { include? wrt.name }

  desc 'Includes the level'
  result.prove { include? wrt.logger_level.to_s }

  desc 'Includes details about its pushed devices'
  result.prove { include? dvc.name }

  desc "Includes details about its logger's appenders"
  result.prove { include? logger_device.name }
end
