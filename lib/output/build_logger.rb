module Output
  class Writer
    module BuildLogger
      extend self

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        extend self

        def build_logger(name, level, device_options)
          logger = Logging.logger[name]
          logger.level = level
          logger.appenders = Output::Devices.build_device(device_options[:device], device_options)
          Extension.! logger, LevelName
          logger
        end
      end

      module LevelName
        def level_name
          level_names = Logging::LNAMES
          level_name =  Logging::levelify level_names[level]
          level_name.to_sym
        end
      end
    end
  end
end
