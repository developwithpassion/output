module Output
  class Writer
    module BuildLogger
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        extend self
        def build_logger(name, level, appender_options)
          logger = Logging.logger[name]
          logger.level = level
          logger.appenders = Output::Appenders.build_appender(name, appender_options)
          logger
        end

      end
    end
  end
end
