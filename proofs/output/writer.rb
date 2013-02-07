require_relative '../proofs_init'

title 'Writer'

module Output
  class Writer
    module Proof
      def logger_level?(level_name)
        logger_level == level_name
      end
    end
  end
end

def builder
  Output::Writer::BuildLogger::ClassMethods
end

def writer
  device_options = { :device => :stdout, :pattern => '%m\n' }
  logger = builder.build_logger 'some name', :debug, device_options

  Output::Writer.new 'some name', :debug, nil, logger, device_options
end

proof 'Its logger level should be the name of the underlying numeric logger level' do
  writer.prove { logger_level? :debug }
end

proof 'Changing its logger level should update its loggers level' do
  wtr = writer
  wtr.logger_level = :info
  wtr.prove { logger_level? :info }
end

proof 'Is initially enabled' do
  writer.prove { enabled? }
end
