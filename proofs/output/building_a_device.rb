require_relative '../proofs_init'

title 'Building A Device'

def builder
  Output::Devices
end

proof 'Builds device using name and provided options' do
  device = builder.build_device(:some_name, :device => :string_io, :pattern => '%m\n')
  device.prove { name == 'some_name' && is_a?(Logging::Appenders::StringIo) }
end

heading 'Building a device without specifying any options' do
  proof 'Builds a string io device with the default pattern' do
    device = builder.build_device(:some_name)
    device.prove { name == 'some_name' && is_a?(Logging::Appenders::StringIo) }
  end
end
