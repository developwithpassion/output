require_relative '../proofs_init'

title 'Adding An Device To A Writer'

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

def writer
  logger = Output::Writer::BuildLogger::ClassMethods.build_logger :some_name, :info, device_options
  Output::Writer.new 'first',:debug, nil, logger, device_options
end

heading 'Adding a device' do

  proof 'Adds the device to its devices' do
    wrt = writer
    new_device =  device :some_name

    wrt.add_device new_device

    wrt.prove { device? new_device }
  end

  proof 'Adds the device to its loggers appenders' do
    wrt = writer
    new_device =  device :some_name

    wrt.add_device new_device

    wrt.prove { logger_device? new_device }
  end
end
