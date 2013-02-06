require_relative '../proofs_init'

title 'Logging Util'

=begin
When the Logging framework is initialized, you can pass in an options set of "levels" that will be used as the only
allowable levels that can be used for the logging session. At that point, any other custom levels that are attempted to
be used will fail. This means that unless all of our tests are using the same "levels" tests can fail if they reinitialize
the logging framework with custom levels. We may want to think about ensuring that each proof file resets the logging framework
so it does not make assumptions about its state.
=end


module Logging
  class Logger
    module Proof
      def name?(name)
        self.name == name
      end
      def level?(level_name)
        Output::Writer::Util.level_name(self.level) == level_name
      end
      def device?
        appenders.count > 0
      end
    end
  end
end

heading 'Logging Levels'

proof 'Default logging level names should be mapped from the logging layer using the positional initialization of its own levels' do
  Output::Writer::Util.level_name(0).prove { self ==  :debug }
  Output::Writer::Util.level_name(1).prove { self ==  :info }
  Output::Writer::Util.level_name(2).prove { self ==  :warn }
  Output::Writer::Util.level_name(3).prove { self ==  :error }
  Output::Writer::Util.level_name(4).prove { self ==  :fatal }
end

heading 'Building Loggers' do
  name = 'the_name'
  level = :info
  device_options = { :device => :stdout, :pattern => '%m\n' }

  build = Proc.new do
    result = Output::Writer::BuildLogger::ClassMethods::build_logger(name, level, device_options)
    result
  end

  proof 'Name is set' do
    logger = build.call
    logger.prove { name? name } 
  end

  proof 'Level is set' do
    logger = build.call
    logger.prove { level? level } 
  end

  proof 'Initial device is added' do
    logger = build.call
    logger.prove { device? } 
  end
end
