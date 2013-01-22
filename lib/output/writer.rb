module Output
  class Writer
    attr_reader :logger
    attr_reader :level
    attr_reader :enabled

    def initialize(logger, level)
      @logger = logger
      @level = level
      enable
    end

    # def self.build(writer_name, level = :debug)
    #   logger = Logging.logger[writer_name]
    #   writer = new logger, level
    # end

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
