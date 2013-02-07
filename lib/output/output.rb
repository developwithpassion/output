require 'ostruct'


module Output
  DEFAULT_LOGGER_LEVEL = :info
  DEFAULT_PATTERN = '%m\n'
  DEFAULT_DEVICE = :stdout

  def self.included(base)
    base.extend ClassMethods
  end

  def disable
    each_writer { |w| w.disable }
    if block_given?
      yield
      enable
    end
  end

  def enable
    each_writer { |w| w.enable }
  end

  def write(method, message)
    send method, message
  end

  def writer(name)
    send self.class.writer_attribute(name)
  end

  def build_writer(name, level, device_options = nil, message_transformer=nil)
    device_options ||= self.class.build_device_options
    logger_name = Writer::Naming.fully_qualified(self.class, name)
    writer = Writer.build name, level, message_transformer, self.level, logger_name, device_options
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

  def initial_level?
    level == self.class.logger_level
  end

  def levels
    @levels ||= []
  end

  def reset_level
    @level = self.class.logger_level

    each_writer do |writer|
      writer.reset_level
    end
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

  def pop_level
    level = levels.shift unless levels.empty?
    self.level = level
    level
  end

  def suspend_device(device, &block)
    return suspend_device__obj(device, &block) if device.is_a? Logging::Appender

    suspend_device__name device, &block
  end

  def suspend_device__name(name, &block)
    device = nil
    each_writer do |writer|
      device ||= writer.device name
    end
    suspend_device__obj device, &block unless device == nil
  end

  def suspend_device__obj(device, &block)
    each_writer do |writer|
      writer.suspend_device device
    end
    yield
    each_writer do |writer|
      writer.push_device device
    end
    device
  end

  def push_device(device, options = {}, &block)
    return push_device__obj(device, &block) if device.is_a? Logging::Appender

    push_device__opts(device, options, &block)
  end

  def push_device__opts(device_type, options = {}, &block)
    options = options.merge(:device => device_type)
    name = options[:name] || device_type 
    options = self.class.build_device_options.merge(options)

    device = Output::Devices.build_device(name, options)
    push_device__obj device, &block
  end

  def push_device__obj(device, &block)
    each_writer do |writer|
      writer.push_device device
    end
    if block_given?
      yield
      pop_device
    end
    device
  end

  def pop_device
    each_writer do |writer|
      writer.pop_device
    end
    nil
  end

  module ClassMethods
    def default_pattern
      @pattern ||= Output::DEFAULT_PATTERN
    end

    def pattern(format)
      @pattern = format
    end

    def default_device_type
      @device ||= ::Output::DEFAULT_DEVICE
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

    def build_device_options(options = {})
      device_options = {}
      device_options[:device] = options[:device] || default_device_type
      device_options[:pattern] = options[:pattern] || default_pattern
      device_options = device_options.merge(options)
      device_options
    end

    def writer_macro(name, options = {}, &message_transformer)
      level = options[:level] || logger_level
      device_options = build_device_options(options)

      WriterMacro.define_writer self, name, level, device_options,  message_transformer
      writer_names << name
    end

    alias :writer :writer_macro

    def writer_attribute(name)
      Writer::Attribute.attribute_name(name)
    end

  end
end
