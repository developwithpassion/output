require_relative '../proofs_init'

title 'Pushing A Device To A Writer'

module Output
  class Writer
    module Proof
      def device?(device)
        devices.include?(device)
      end

      def logger_device?(device)
        @logger.appenders.include?(device)
      end

      def devices?(device, occurences)
        devices.include?(device) &&
          devices.count == occurences
      end

      def logger_devices?(device, occurences)
        @logger.appenders.include?(device) &&
          @logger.appenders.select{|item| item == device}.count == occurences
      end

    end
  end
end

module Logging
  module Appenders
    class StringIo
      def attributes_match?(options)
        self.layout.pattern = options[:pattern]
      end
    end
  end
end

def device
  Logging.appenders.string_io(:first)
end

def writer(device_options = nil)
  device_options ||= { :device => :stdout, :pattern => '%m\n' }
  logger = Logging::logger['First']
  logger.level = :debug

  Output::Writer.new 'first',:debug, nil, logger, device_options
end

heading 'Pushing an device' do
  dvc = device

  proof 'Device is added to list of devices' do
    wrt = writer

    wrt.push_device dvc

    wrt.prove { device? dvc }
  end
  proof 'Device is added to its loggers devices' do
    wrt = writer

    wrt.push_device dvc

    wrt.prove { logger_device? dvc }
  end
end

heading 'Pushing an device that the writer already has' do
  dvc = device

  proof 'Device is not re-added to its list of devices' do
    wrt = writer

    wrt.push_device dvc
    wrt.push_device dvc

    wrt.prove { devices? dvc, count = 1 }

  end

  proof 'Device is not re-added to its loggers devices' do
    wrt = writer

    wrt.push_device dvc
    wrt.push_device dvc

    wrt.prove { logger_devices? dvc, count = 1 }

  end
end

heading 'Pushing an device with a block' do
  dvc = device

  proof 'Device is added to list of devices' do
    wrt = writer

    wrt.push_device dvc do
      wrt.prove { device? dvc }
    end
  end

  proof 'Device is added to its loggers devices' do
    wrt = writer

    wrt.push_device dvc do
      wrt.prove { logger_device? dvc }
    end
  end

  proof 'Device is removed from its list of devices after running the block' do
    wrt = writer

    wrt.push_device dvc do
    end
    wrt.prove { !device? dvc }
  end

  proof 'Device is removed from its loggers devices after running the block' do
    wrt = writer

    wrt.push_device dvc do
    end
    wrt.prove { !logger_device? dvc }
  end
end

heading 'Pushing an device using default options' do
  proof 'Device is added to list of devices' do
    wrt = writer

    dvc = wrt.push_device :string_io

    wrt.prove { device? dvc }
  end

  proof 'Device is added to loggers devices' do
    wrt = writer

    dvc = wrt.push_device :string_io

    wrt.prove { logger_device? dvc }
  end

  proof 'Device options are set from writers device options' do
    wrt = writer

    dvc = wrt.push_device :string_io

    dvc.prove { attributes_match? wrt.device_options }
  end

  proof 'Device is the specified device type' do
    wrt = writer

    dvc = wrt.push_device :string_io
    dvc.prove { self.class == Logging::Appenders::StringIo }
  end

end

heading 'Pushing an device using specified options' do
  proof 'Device options are set from specified options' do
    wrt = writer
    pattern = '%m %m \n'

    new_options = { :pattern => pattern }

    dvc = wrt.push_device :string_io, new_options

    dvc.prove { attributes_match? new_options }
  end
end
