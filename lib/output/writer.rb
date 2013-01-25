module Output
  class Writer
    attr_reader :name
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

    def self.build(writer_name, level=Output::DEFAULT_LOGGER_LEVEL, message_transformer=nil, logger_level=Output::DEFAULT_LOGGER_LEVEL, logger_name=nil)
      logger_name ||= writer_name
      logger = build_logger(logger_name, logger_level)
      writer = new(writer_name, level, message_transformer, logger)
    end

    def self.build_logger(name, level)
      logger = Logging.logger[name]
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

    def logger_level
      @logger.level
    end

    def logger_level=(level)
      @logger.level = level
    end

    def logger_name
      @logger.name
    end

    def write(message)
      message = message_transformer.call message if message_transformer
      @logger.send level, message if enabled?
    end

    module Naming
      extend self

      def fully_qualified(mod, writer_name)
        namespace = mod.name
        writer_name = camel_case(writer_name)
        "#{namespace}::#{writer_name}"
      end

      def camel_case(name)
        name.to_s.split('_').collect { |s| s.capitalize }.join
      end
    end
  end
end
