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
      def correct_name_and_level?(name,level)
        level == level
        name == name
      end
    end
  end
end

heading 'Logging Levels'

proof 'Default logging level names should be mapped from the logging layer using the positional initialization of its own levels' do
  Output::Writer::Util.level_name(0).prove { self ==  :debug }
  Output::LoggingUtil.level_name(1).prove { self ==  :info }
  Output::LoggingUtil.level_name(2).prove { self ==  :warn }
  Output::LoggingUtil.level_name(3).prove { self ==  :error }
  Output::LoggingUtil.level_name(4).prove { self ==  :fatal }
end


heading 'Building Loggers'

proof 'Default logger should be initialized with a stdout logger and a level of debug' do
  name = 'name'
  level = :info

  logger = Output::LoggingUtil.build_logger(name, level)
  logger.prove { correct_name_and_level? name, level } 
end
