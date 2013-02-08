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

def device_options(name)
  { :name => name, :device => :stdout, :pattern => '%m\n' }
end

def device(name)
  Output::Devices.build_device(:stdout, device_options(name)) 
end

def builder
  Output::Writer::BuildLogger::ClassMethods
end

def writer
  Output::Writer.build 'some name', :debug, nil, :debug, nil, device_options(:some_name)
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
    wrt.push_device new_device

    wrt.suspend_device :some_name do
      wrt.prove { not device? new_device }
    end
  end

  proof 'Remove the device from its loggers appenders' do
    wrt = writer
    new_device =  device :some_name
    wrt.push_device new_device

    wrt.suspend_device :some_name do
      wrt.prove { not logger_device? new_device }
    end
  end


  proof 'Adds the device back onto the devices list after the block has run' do
    wrt = writer
    new_device =  device :some_name
    wrt.push_device new_device
    ran = false

    wrt.suspend_device :some_name do
      ran = true
    end

    wrt.prove { device? new_device }
  end
end
