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
      result = nil
      logger.appenders.each do|device|
        result = device if device.name == name.to_s
      end
      result
    end

    def number_of_stack_devices
      devices.count
    end

    def logger_device?(device)
      logger.appenders.include? device
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

    class DeviceSuspension
      include Initializer

      attr_accessor :logger_device
      attr_accessor :writer_device

      initializer :writer, :device

      def restore
        unless device.nil?
          writer.push_device device if (writer_device)
          writer.add_device device if (logger_device)
        end
      end


      def suspend
        self.logger_device = writer.logger_device? device
        self.writer_device = writer.device? device

        writer.remove_device device if logger_device
        writer.devices.delete device if writer_device
      end
    end

    def suspend_device__obj(device, &block)
      suspension = DeviceSuspension.new self, device
      suspension.suspend

      if block_given?
        yield
        suspension.restore
      end
      device
    end

    def push_device(device, options = {},  &block)
      return device if device.nil?
      return push_device__obj(device, &block) if device.is_a? Logging::Appender

      push_device__opts(type = device, options, &block)
    end

    def push_device__obj(device, &block)
      raise "The writer:[#{self.name}] already has a device named #{device.name}:[#{device.class}]" if device?(device)

      devices.push device

      add_device device

      if block_given?
        yield
        pop_device
      end
      device
    end

    def push_device__opts(type, options = {}, &block)
      options = self.device_options.merge(options)
      name = options[:name] || type

      raise "Writer:[#{self.name}] - already has a device named [#{name}]. It cannot be pushed the device again" unless device(name).nil?

      device = Output::Devices.build_device(type, options)
      push_device__obj device, &block
    end

    def pop_device
      return if devices.count == 0
      device = devices.pop
      remove_device device
    end

    def device?(device)
      return false if device.nil?
      
      devices.include?(device) || devices.any? { |dvc| dvc.name == device.name }
    end

    def to_s
      details = "Writer : #{self.name}\n"
      details << "\tLevel : #{self.level}\n"
      details << "\tDevice Stack : \n"
      devices.each do |device|
        details << "\t\tDevice : #{device.name} - #{device.class}\n"
      end
      details << "\tLogger Appenders : \n"
      logger.appenders.each do |appender|
        details << "\t\t\Appender : #{appender.name} - #{appender.class}\n"
      end
      details
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
