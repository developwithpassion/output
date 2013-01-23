module Output
  class Writer
    attr_reader :name
    attr_reader :logger
    attr_accessor :level
    attr_reader :enabled

    # def initialize(logger, level)
    #   @logger = logger
    #   @level = level
    #   enable
    # end

    def initialize(name, logger, level)
      @name = name
      @logger = logger
      @level = level
      enable
    end

    def self.build(writer_name, level, logger_level=Output::DEFAULT_LOGGER_LEVEL)
      logger = logger(writer_name, logger_level)
      writer = new(writer_name, logger, level)
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
      # puts
      # puts "writer name: #{name}"
      # puts "writer object: #{self.inspect}"
      # puts "writer.write"
      # puts "writer level: #{level}"
      # puts "logger level: #{logger.level}"

      logger.send level, message if enabled?
    end
  end
end
