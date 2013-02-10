require_relative '../proofs_init'
require_relative '../example/builders'

include OutputProofs

title 'Getting a writer device by name'
   

def writer
  Builders.writer
end

proof 'Gets the named device' do
  wrt = writer
  name = "the_device"

  device = wrt.push_device(:string_io, :name => :blah)
  found = wrt.device(:blah)
  
  found.prove { self == device }
end

proof 'Return nil if the named device is not found' do
  wrt = writer
  name = "the_device"

  found = wrt.device(:non_existant_device)
  
  found.prove { nil? }
end
