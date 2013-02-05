require 'ostruct'

module Output
  DEFAULT_LOGGER_LEVEL = :info

  def self.included(base)
    base.extend ClassMethods
  end

  def disable
    each_writer { |w| w.disable }
  end

  def write(method, message)
    send method, message
  end

  def writer(name)
    send self.class.writer_attribute(name)
  end

  def build_writer(name, level, message_transformer=nil)
    logger_name = Writer::Naming.fully_qualified(self.class, name)
    writer = Writer.build name, level, message_transformer, self.level, logger_name
    writer
  end

  def each_writer
    self.class.writer_names.each do |name|
      writer = send self.class.writer_attribute(name)
      yield writer
    end
  end

  def level
    @level ||= self.class.logger_level
  end

  def level=(level)
    @level = level
    each_writer { |w| w.logger_level = level }
    level
  end

  def levels
    @levels ||= []
  end

  def push_level(level)
    levels.unshift self.level
    self.level = level

    if block_given?
      yield
      self.level = pop_level
    end
    
    level
  end

  def push_appender(appender)
    each_writer do|writer|
      writer.push_appender appender
    end
    if block_given?
      yield
      pop_appender
    end
    appender
  end

  def pop_appender
    each_writer do|writer|
      writer.pop_appender
    end
    nil
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

    def logger_level=(level=nil)
      @logger_level = level unless level.nil?
      @logger_level
    end
    alias :level :logger_level=

    def writer_names
      @writer_names ||= []
    end

    def writer_macro(name, options = {}, &message_transformer)
      level = options[:level] || logger_level
      WriterMacro.define_writer self, name, level, message_transformer
      writer_names << name
    end
    alias :writer :writer_macro

    def writer_attribute(name)
      Writer::Attribute.attribute_name(name)
    end
  end
end
