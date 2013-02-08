require_relative '../proofs_init'

title 'Building A Device'

def builder
  Output::Devices
end

proof 'Builds device using name and provided options' do
  device = builder.build_device(:string_io, :name => :some_name, :pattern => '%m\n')
  device.prove { name == 'some_name' && is_a?(Logging::Appenders::StringIo) }
end

heading 'Building a device without specifying any options' do
  proof 'Builds a string io device with the default pattern' do
    device = builder.build_device(:string_io)
    device.prove { name == 'string_io' && is_a?(Logging::Appenders::StringIo) }
  end
end
