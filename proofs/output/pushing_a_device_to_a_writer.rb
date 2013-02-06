require_relative '../proofs_init'

title 'Pushing An Device To A Writer'

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

def new_device
  Logging.appenders.string_io(:first)
end

def new_writer(device_options = nil)
  device_options ||= { :device => :stdout, :pattern => '%m\n' }
  logger = Logging::logger['First']
  logger.level = :debug

  Output::Writer.new 'first',:debug, nil, logger, device_options
end

heading 'Pushing an device' do
  device = new_device

  proof 'Device is added to list of devices' do
    writer = new_writer

    writer.push_device device

    writer.prove { device? device }
  end
  proof 'Device is added to its loggers devices' do
    writer = new_writer

    writer.push_device device

    writer.prove { logger_device? device }
  end
end

heading 'Pushing an device that the writer already has' do
  device = new_device

  proof 'Device is not re-added to its list of devices' do
    writer = new_writer

    writer.push_device device
    writer.push_device device

    writer.prove { devices? device, count = 1 }

  end

  proof 'Device is not re-added to its loggers devices' do
    writer = new_writer

    writer.push_device device
    writer.push_device device

    writer.prove { logger_devices? device, count = 1 }

  end
end

heading 'Pushing an device with a block' do
  device = new_device

  proof 'Device is added to list of devices' do
    writer = new_writer

    writer.push_device device do
      writer.prove { device? device }
    end
  end
  proof 'Device is added to its loggers devices' do
    writer = new_writer

    writer.push_device device do
      writer.prove { logger_device? device }
    end
  end

  proof 'Device is removed from its list of devices after running the block' do
    writer = new_writer

    writer.push_device device do
    end
    writer.prove { !device? device }
  end

  proof 'Device is removed from its loggers devices after running the block' do
    writer = new_writer

    writer.push_device device do
    end
    writer.prove { !logger_device? device }
  end
end

heading 'Pushing an device using default options' do
  proof 'Device is added to list of devices' do
    writer = new_writer

    device = writer.push_device_from_opts :string_io

    writer.prove { device? device }
  end

  proof 'Device is added to loggers devices' do
    writer = new_writer

    device = writer.push_device_from_opts :string_io

    writer.prove { logger_device? device }
  end

  proof 'Device options are set from writers device options' do
    writer = new_writer

    device = writer.push_device_from_opts :string_io

    device.prove { attributes_match? writer.device_options }
  end

  proof 'Device is the specified device type' do
    writer = new_writer

    device = writer.push_device_from_opts :string_io
    device.prove { self.class == Logging::Appenders::StringIo }
  end

end

heading 'Pushing an device using specified options' do
  proof 'Device options are set from specified options' do
    writer = new_writer
    pattern = '%m %m \n'

    new_options = { :pattern => pattern }

    device = writer.push_device_from_opts :string_io, new_options

    device.prove { attributes_match? new_options }
  end
end
