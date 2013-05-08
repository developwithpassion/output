require_relative '../proofs_init'
require_relative '../example/builders'

include OutputProofs

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

def logger
  Builders.logger('some name')
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
