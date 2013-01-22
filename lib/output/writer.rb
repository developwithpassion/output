module Output
  class Writer
    attr_reader :logger
    attr_accessor :level
    attr_reader :enabled

    def initialize(logger, level)
      @logger = logger
      @level = level
      enable
    end

    def self.build(writer_name, level, logger_level=Output::DEFAULT_LEVEL)
      logger = logger(writer_name, logger_level)
      writer = new(logger, level)
    end

    def self.logger(name, level)
      logger = Logging.logger[name.to_s]
      logger.level = level

      layout = Logging.layouts.pattern(:pattern => '%m\n')
      stdout_appender = Logging::Appenders::Stdout.new('stdout', :layout => layout)

      logger.appenders = stdout_appender

      logger
    end

    def threshold
      logger.level
    end

    def threshold=(val)
      logger.level = val
    end

    def disable
      @enabled = false
    end

    def enable
      @enabled = true
    end

    def enabled?
      @enabled
    end

    def write(message)
      logger.send level, message if enabled?
    end
  end
end
