module Output
  class WriterMacro
    include Initializer

    attr_reader :output_class
    attr_reader :name
    attr_reader :level
    attr_reader :message_transformer

    initializer :output_class, :name, :level, :message_transformer

    def self.define_writer(output_class, name, level, message_transformer)
      macro = new output_class, name, level, message_transformer
      macro.define_writer
    end

    def define_writer
      define_getter
      define_setter
      define_write_method
    end

    def define_getter
      name = self.name
      level = self.level
      message_transformer = self.message_transformer

      attribute_name, var_name = Writer::Naming.attribute_properties(name)

      output_class.send :define_method, attribute_name do
        writer = instance_variable_get var_name

        unless writer
          writer = build_writer(name, level, message_transformer) unless writer
          instance_variable_set var_name, writer
        end

        writer
      end
    end

    def define_setter
      attribute_name, var_name = Writer::Naming.attribute_properties(name)

      output_class.send :define_method, "#{attribute_name}=" do |writer|
        writer.logger_level = level
        instance_variable_set var_name, writer
        writer
      end
    end

    def define_write_method
      name = self.name
      output_class.send :define_method, name do |message|
        writer(name).write message
        message
      end
    end
  end
end

