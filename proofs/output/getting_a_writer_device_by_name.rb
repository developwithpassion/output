require_relative '../proofs_init'


title 'Getting a writer device by name'
   
def builder
  Output::Writer::BuildLogger::ClassMethods
end

def writer
  device_options = { :device => :stdout, :pattern => '%m\n' }
  logger = builder.build_logger 'some name', :debug, device_options

  Output::Writer.new 'some name', :debug, nil, logger, device_options
end

proof 'Gets the named device' do
  wrt = writer
  name = "the_device"

  device = wrt.push_device(:string_io)
  found = wrt.find_device(:string_io)
  
  found.prove { self == device }
end

proof 'Return nil if the named device is not found' do
  wrt = writer
  name = "the_device"

  found = wrt.find_device(:string_io)
  
  found.prove { nil? }
end
