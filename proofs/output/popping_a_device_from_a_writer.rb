require_relative '../proofs_init'

title 'Popping An Device From A Writer'

module Output
  class Writer
    module Proof
      def device?(device)
        devices.include?(device) &&
          @logger.appenders.include?(device)
      end
      def logger_device?(device)
        @logger.appenders.include?(device)
      end
    end
  end
end

def new_device
  Logging.appenders.string_io(:something)
end

def new_writer
  logger = Logging::logger['Something']
  logger.level = :debug
  device_options ||= { :device => :stdout, :pattern => '%m\n' }

  Output::Writer.new 'first',:debug, nil, logger, device_options
end


proof 'Removes it from the list of devices' do
  device = new_device
  writer = new_writer
  writer.push_device device

  writer.pop_device

  writer.prove { not device? device }
end

proof 'Removes it from its logger' do
  device = new_device
  writer = new_writer
  writer.push_device device

  writer.pop_device

  writer.prove { not logger_device? device }
end
