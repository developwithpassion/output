require_relative '../proofs_init'

title 'Building a Logger'


module Logging
  class Logger
    module Proof
      def name?(name)
        self.name == name
      end
      def level?(level_name)
        level_name == self.level_name
      end
      def device?
        appenders.count > 0
      end
    end
  end
end

def device_options
  { :name => :stdout, :pattern => '%m\n' }
end

def writer
  Output::Writer.build 'first',:debug, nil, :debug, nil, device_options
end

def logger
  name = 'some name'
  level = :info
  device_options = { :device => :stdout, :pattern => '%m\n' }

  logger = Output::Writer::BuildLogger::ClassMethods::build_logger(name, level, device_options)
  logger
end

proof 'Name is set' do
  logger.prove { name? 'some name' } 
end

proof 'Level is set' do
  logger.prove { level? :info } 
end

proof 'Initial device is added' do
  logger.prove { device? } 
end
