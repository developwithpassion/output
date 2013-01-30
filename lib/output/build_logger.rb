module Output
  class Writer
    module BuildLogger
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def build_logger(name, level)
          logger = Logging.logger[name]
          logger.level = level

          layout = Logging.layouts.pattern(:pattern => '%m\n')
          stdout_appender = Logging::Appenders::Stdout.new('stdout', :layout => layout)

          logger.appenders = stdout_appender

          logger
        end
      end
    end
  end
end
