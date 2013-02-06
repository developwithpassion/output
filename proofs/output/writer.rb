require_relative '../proofs_init'

title 'Writer'

module Output
  class Writer
    module Proof
      def logger_level_named?(level_name)
        name = logger_level
        name == level_name
      end

      def change_level_to?(new_level_name)
        logger_level = new_level_name
        logger_level == new_level_name
      end
    end
  end
end

def writer(device_options = {})
  logger = Logging::logger['First']
  logger.level = :debug
  device_options ||= { :device => :stdout, :pattern => '%m\n' }

  Output::Writer.new 'first',:debug, nil, logger, device_options
end

proof 'Its logger level should be the symbolic representation of the level' do
  writer.prove { logger_level_named? :debug }
end

proof 'Changing its logger level should update its loggers level accordingly' do
  writer.prove { change_level_to? :info }
end

proof 'Is initially enabled' do
  writer.prove { enabled? }
end
