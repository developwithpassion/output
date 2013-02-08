module Output
  class Writer
    include BuildLogger
    include Initializer

    attr_reader :name
    attr_accessor :level
    attr_reader :message_transformer
    attr_reader :enabled
    attr_writer :devices

    initializer :name, :level, :message_transformer, :logger, :device_options

    def self.build(writer_name, level=Output::DEFAULT_LOGGER_LEVEL, message_transformer=nil, logger_level=Output::DEFAULT_LOGGER_LEVEL, logger_name=nil, device_options)
      logger_name ||= writer_name
      logger = build_logger(logger_name, logger_level, device_options)
      writer = new(writer_name, level, message_transformer, logger, device_options)
    end

    def devices
      @devices ||= []
    end

    def disable
      @enabled = false
    end

    def enable
      @enabled = true
    end

    def enabled?
      @enabled = true if @enabled.nil?
      @enabled
    end

    def logger_level
      @logger.level_name
    end

    def logger_level=(level)
      @logger.level = level
    end

    def reset_level
      self.logger_level = level
    end

    def initial_logger_level?
      logger_level == level
    end

    def logger_name
      @logger.name
    end

    def write(message)
      message = message_transformer.call message if message_transformer
      @logger.send level, message if self.enabled?
    end

    def add_device(device)
      @logger.add_appenders device
      device
    end

    def device(name)
      devices.select do |device|
        device.name == name.to_s
      end.first
    end

    def remove_device(device)
      @logger.remove_appenders device
      device
    end

    def logging_appender?(arg)
      arg.is_a? Logging::Appender
    end

    def suspend_device(device, &block)
      return suspend_device__obj device, &block if logging_appender?(device)

      suspend_device__name device, &block
    end

    def suspend_device__name(name, &block)
      dvc = device name
      suspend_device__obj dvc, &block
    end

    def suspend_device__obj(device, &block)
      remove_device device
      devices.delete device

      if block_given?
        yield
        push_device__obj device
      end
      device
    end

    def push_device__obj(device, &block)
      raise "The device #{device.name} has already been pushed" if devices.include?(device)

      devices.push device

      add_device device

      if block_given?
        yield
        pop_device
      end
      device
    end

    def push_device(device, options = {},  &block)
      return push_device__obj(device, &block) if device.is_a? Logging::Appender

      push_device__opts(device, options, &block)
    end

    def push_device__opts(name, options = {}, &block)
      options = self.device_options.merge(options)

      raise "The device #{name} has already been pushed" unless device(name).nil?

      device = Output::Devices.build_device(name, options)
      push_device__obj device, &block
    end

    def pop_device
      return if devices.count == 0
      device = devices.pop
      remove_device device
    end

    def device?(device)
      devices.include?(device)
    end

    class Attribute
      include Initializer

      attr_reader :name
      attr_reader :variable_name

      initializer :name, :variable_name

      def self.build(name)
        attribute_name = attribute_name(name)
        variable_name = variable_name(name)
        new attribute_name, variable_name
      end

      def self.attribute_name(name)
        :"#{name}_writer"
      end

      def self.variable_name(name)
        :"@#{name}_writer"
      end
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
