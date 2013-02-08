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
  { :device => :stdout, :name => :stdout, :pattern => '%m\n' }
end

def device
  Output::Devices.build_device(:stdout, device_options)
end

def writer
  Output::Writer.build 'first',:debug, nil, :debug, nil, device_options
end

heading 'Adding a device' do

  proof 'Adds the device to its loggers appenders' do
    wrt = writer
    new_device =  device

    wrt.add_device new_device

    wrt.prove { logger_device? new_device }
  end
end
