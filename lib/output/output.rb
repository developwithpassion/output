module Output
  DEFAULT_LOGGER_LEVEL = :info

  def self.included(base)
    base.extend ClassMethods
  end

  def disable
    self.class.writers.disable
  end

  def write(method, message)
    send method, message
  end

  def level
    @level ||= self.class.logger_level
  end

  def level=(level)
    @level = level
    self.class.writers.logger_level = level
  end

  def levels
    @levels ||= []
  end

  def push_level(level)
    levels.unshift level
    self.level = level

    if block_given?
      yield
      level = pop_level
    end
    
    level
  end

  def pop_level
    level = levels.shift unless levels.empty?
    self.level = level
    level
  end

  module ClassMethods
    def logger_level
      @logger_level ||= Output::DEFAULT_LOGGER_LEVEL
    end

    def level(level=nil)
      @logger_level = level unless level.nil?
      @logger_level
    end

    def writers
      @writers ||= [].extend Writers
    end

    def writer(name, options = {}, &transform_block)
      transform = transform_block || ->(message) { message } 

      level = options.fetch(:level, name)

      writer = Writer.build(name, level, logger_level)

      define_writer_accessor name, writer

      define_write_method name, writer, transform

      writers << writer
    end

    def define_writer_accessor(name, writer)
      accessor_name = "#{name}_writer"

      # TODO if setting, make the accessor a setting
      # otherwise, it's just a plain old accessor
      setting accessor_name, writer
    end

    def define_write_method(name, writer, transform)
      send :define_method, name do |message|
        message = transform.call message
        writer.write message
        message
      end
    end
  end
end
