module Output
  class Writer
    module BuildLogger
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        extend self
        def build_logger(name, level, device_options)
          logger = Logging.logger[name]
          logger.level = level
          logger.appenders = Output::Devices.build_device(name, device_options)
          logger
        end

      end
    end
  end
end
