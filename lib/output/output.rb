require 'ostruct'

class WriterDefinition < OpenStruct
  def flatten
    return name, level, message_transformer
  end
end

module Output
  def self.included(base)
    base.extend ClassMethods
  end

  # TODO needs to be called on "writers" instance method
  # - uses writer_definitions class method to get names
  # - collect writer instances for each name in writer_definitions
  def disable
    self.class.writers.disable
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
    self.class.writers.logger_level = level
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

  def build_writer(writer_definition)
    name, level, message_transformer = writer_definition.flatten
    writer = Writer.build name, level, message_transformer, self.level
  end

  def writers
    writers = self.class.writer_names.collect do |name|
      send self.class.writer_accessor(name)
    end

    writers.extend Writers
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
      message_transformer = message_transformer || ->(message) { message } 
      level = options.fetch(:level, name)

      definition = WriterDefinition.new
      definition.name = name
      definition.level = level
      definition.message_transformer = message_transformer

      writer_definitions[name] = definition

      define_writer_accessor definition

      define_write_method name
    end
    alias :writer :writer_macro

    def define_writer_accessor(definition)
      define_writer_getter(definition)
      define_writer_setter(definition)
    end

    def define_writer_getter(definition)
      accessor_name = writer_accessor(definition.name)
      var_name = :"@#{accessor_name}"

      send :define_method, accessor_name do
        writer = instance_variable_get var_name

        unless writer
          writer = build_writer(definition) unless writer
          instance_variable_set var_name, writer
        end

        writer
      end
    end

    def define_writer_setter(definition)
      writer_name = definition.name
      accessor_name = writer_accessor(writer_name)
      var_name = :"@#{accessor_name}"

      send :define_method, "#{accessor_name}=" do |writer|
        writer.logger.level = self.class.logger_level
        instance_variable_set var_name, writer
        writer
      end
    end

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
