require_relative '../proofs_init'

title 'Building A Device'

def builder
  Output::Devices
end

heading 'Building a device using its name and options' do
  proof 'Build a string io device' do
    device = builder.build_device(:string_io, :name => :some_name, :pattern => '%m\n')
    device.prove { name == 'some_name' && is_a?(Logging::Appenders::StringIo) }
  end
  proof 'Build a file io device' do
    device = builder.build_device(:file, :name => :some_name, :pattern => '%m\n', :filename => 'some_file.out')
    device.prove { name == 'some_name' && is_a?(Logging::Appenders::RollingFile) }
    File.delete('some_file.out') if File.exist?('some_file.out')
  end
  proof 'Build a stdout device' do
    device = builder.build_device(:stdout, :name => :some_name, :pattern => '%m\n')
    device.prove { name == 'some_name' && is_a?(Logging::Appenders::Stdout) }
  end
  proof 'Build a stderr device' do
    device = builder.build_device(:stderr, :name => :some_name, :pattern => '%m\n')
    device.prove { name == 'some_name' && is_a?(Logging::Appenders::Stderr) }
  end
end

heading 'Building a device without specifying any options' do
  proof 'Builds a string io device with the default pattern' do
    device = builder.build_device(:string_io)
    device.prove { name == 'string_io' && is_a?(Logging::Appenders::StringIo) }
  end
end

