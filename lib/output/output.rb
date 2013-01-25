require 'ostruct'

module Output
  class WriterDefinition < OpenStruct
    def flatten
      return name, level, message_transformer
    end
  end

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
    send self.class.writer_accessor(name)
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

  def pop_level
    level = levels.shift unless levels.empty?
    self.level = level
    level
  end

  def build_writer(name, level, message_transformer)
    logger_name = Writer::Naming.fully_qualified(self.class, name)
    writer = Writer.build name, level, message_transformer, self.level, logger_name
  end

  def build_writer_(definition)
    build_writer *definition.flatten
  end

  def each_writer
    self.class.writer_names.each do |name|
      writer = send self.class.writer_accessor(name)
      yield writer
    end
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

    def writer_definitions
      @writer_definitions ||= {}
    end

    def writer_names
      writer_definitions.keys
    end

    def writer_macro(name, options = {}, &message_transformer)
      level = options.fetch(:level, name)

      definition = WriterDefinition.new
      definition.name = name
      definition.level = level
      definition.message_transformer = message_transformer

      writer_definitions[name] = definition

      macro = WriterMacro.new self, name, level, message_transformer
      macro.define_writer_accessor

      # define_writer_accessor definition

      define_write_method name
    end
    alias :writer :writer_macro

    # TODO this is now coded here, and in WriterMacro
    def writer_accessor(name)
      :"#{name}_writer"
    end

    def define_write_method(name)
      send :define_method, name do |message|
        writer(name).write message
        message
      end
    end
  end
end
