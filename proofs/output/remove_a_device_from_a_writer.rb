require_relative '../proofs_init'

title 'Remove A Device From A Writer'

module Output
  class Writer
    module Proof
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


proof 'Remove the device from its loggers appenders' do
  wrt = writer
  new_device =  device :some_name
  wrt.add_device new_device

  wrt.remove_device new_device

  wrt.prove { not logger_device? new_device }
end
