require 'ostruct'

class WriterDefinition < OpenStruct
  def flatten
    return name, level, transform_block
  end
end

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

  def build_writer(definition)
    name, level, transform_block = definition.flatten
    writer = Writer.build name, level, transform_block, self.level
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

    def writers
      @writers ||= {}.extend Writers
    end
    # TODO rename the method after redesign is done
    alias :writer_definitions :writers

    def writer(name, options = {}, &transform_block)
      transform_block = transform_block || ->(message) { message } 
      level = options.fetch(:level, name)

      definition = WriterDefinition.new
      definition.name = name
      definition.level = level
      definition.transform_block = transform_block

      writer_definitions[name] = definition

      define_writer_accessor definition

      define_write_method name
    end

    def define_writer_accessor(definition)
      writer_name = definition.name
      accessor_name = writer_accessor(writer_name)
      var_name = :"@#{accessor_name}"

      # TODO consider JP's design in regards to an "accessor" object (or module)
      # to encapsulate the definition (generation) of the getter/setter methods

      # TODO move to "define_setter" method
      send :define_method, accessor_name do
        writer = instance_variable_get var_name

        unless writer
          writer = build_writer(definition) unless writer
          instance_variable_set var_name, writer
        end

        writer
      end

      # TODO move to "define_getter" method
      send :define_method, "#{accessor_name}=" do |writer|
        instance_variable_set var_name, writer
        writers[name] = writer
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
