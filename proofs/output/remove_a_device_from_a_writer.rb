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
  { :device => :stdout, :name => :first, :pattern => '%m\n' }
end

def device
  Output::Devices.build_device(:stdout, device_options) 
end

def writer
  Output::Writer.build 'first', :debug, nil, :debug, nil, device_options
end


proof 'Remove the device from its loggers appenders' do
  wrt = writer
  new_device =  device
  wrt.add_device new_device

  wrt.remove_device new_device

  wrt.prove { not logger_device? new_device }
end
