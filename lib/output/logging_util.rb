module Output
  module LoggingUtil
    extend self

    def level_name(level_number)
      level_names = Logging::LNAMES
      level_name =  Logging::levelify level_names[level_number]
      level_name.to_sym
    end

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
