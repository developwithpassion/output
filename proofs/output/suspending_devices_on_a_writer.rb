require_relative '../proofs_init'

title 'Suspending Devices On A Writer'

module Output
  class Writer
    module Proof
      def device?(device)
        devices.include?(device)
      end

      def logger_device?(device)
        @logger.appenders.include?(device)
      end
    end
  end
end

def device_options
  { :device => :stdout, :pattern => '%m\n' }
end

def device(name)
  Output::Devices.build_device(name, device_options) 
end

def builder
  Output::Writer::BuildLogger::ClassMethods
end

def writer
  device_options = { :device => :stdout, :pattern => '%m\n' }
  logger = builder.build_logger 'some name', :debug, device_options

  Output::Writer.new 'some name', :debug, nil, logger, device_options
end

heading 'By instance' do
  proof 'Removes the device from its devices' do
    wrt = writer
    new_device =  device :some_name
    wrt.add_device new_device

    wrt.suspend_device new_device do
      wrt.prove { not device? new_device }
    end
  end

  proof 'Remove the device from its loggers appenders' do
    wrt = writer
    new_device =  device :some_name
    wrt.add_device new_device

    wrt.suspend_device new_device do
      wrt.prove { not logger_device? new_device }
    end
  end


  proof 'Adds the device back onto the devices list after the block has run' do
    wrt = writer
    new_device =  device :some_name
    wrt.add_device new_device
    ran = false

    wrt.suspend_device new_device do
      ran = true
    end

    wrt.prove { device? new_device }
  end
end

heading 'By name' do
  proof 'Removes the device from its devices' do
    wrt = writer
    new_device =  device :some_name
    wrt.add_device new_device

    wrt.suspend_device :some_name do
      wrt.prove { not device? new_device }
    end
  end

  proof 'Remove the device from its loggers appenders' do
    wrt = writer
    new_device =  device :some_name
    wrt.add_device new_device

    wrt.suspend_device :some_name do
      wrt.prove { not logger_device? new_device }
    end
  end


  proof 'Adds the device back onto the devices list after the block has run' do
    wrt = writer
    new_device =  device :some_name
    wrt.add_device new_device
    ran = false

    wrt.suspend_device :some_name do
      ran = true
    end

    wrt.prove { device? new_device }
  end
end
