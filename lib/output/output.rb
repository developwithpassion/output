require 'ostruct'


module Output
  DEFAULT_LOGGER_LEVEL = :info
  DEFAULT_PATTERN = '%m\n'
  DEFAULT_APPENDER = :stdout

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

  def build_writer(name, level, appender_options = nil, message_transformer=nil)
    appender_options ||= self.class.build_appender_options
    logger_name = Writer::Naming.fully_qualified(self.class, name)
    writer = Writer.build name, level, message_transformer, self.level, logger_name, appender_options
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
    def default_pattern
      @pattern ||= Output::DEFAULT_PATTERN
    end

    def pattern(format)
      @pattern = format
    end

    def default_appender_type
      @device ||= ::Output::DEFAULT_APPENDER
    end

    def device(device)
      @device = device
    end

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

    def build_appender_options(options = {})
      appender_options = {}
      appender_options[:appender] = options[:appender] || default_appender_type
      appender_options[:pattern] = options[:pattern] || default_pattern
      appender_options = appender_options.merge(options)
      appender_options
    end

    def writer_macro(name, options = {}, &message_transformer)
      level = options[:level] || logger_level
      appender_options = build_appender_options(options)

      WriterMacro.define_writer self, name, level, appender_options,  message_transformer
      writer_names << name
    end

    alias :writer :writer_macro

    def writer_attribute(name)
      Writer::Attribute.attribute_name(name)
    end

  end
end
