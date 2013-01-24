module Output
  class Writer
    attr_reader :name
    attr_reader :logger
    attr_accessor :level
    attr_reader :message_transformer
    attr_reader :enabled

    def initialize(name, level, message_transformer, logger)
      @name = name
      @level = level
      @message_transformer = message_transformer
      @logger = logger
      enable
    end

    def self.build(writer_name, level=Output::DEFAULT_LOGGER_LEVEL, message_transformer=nil, logger_level=Output::DEFAULT_LOGGER_LEVEL)
      logger = logger(writer_name, logger_level)
      writer = new(writer_name, level, message_transformer, logger)
    end

    def self.logger(name, level)
      logger = Logging.logger[name.to_s]
      logger.level = level

      layout = Logging.layouts.pattern(:pattern => '%m\n')
      stdout_appender = Logging::Appenders::Stdout.new('stdout', :layout => layout)

      logger.appenders = stdout_appender

      logger
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
      message = message_transformer.call message
      logger.send level, message if enabled?
    end
  end
end
