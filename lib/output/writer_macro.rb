module Output
  class WriterMacro
    include Initializer

    initializer :output_class, :name, :level, :device_options, :message_transformer

    def self.define_writer(output_class, name, level, device_options, message_transformer)
      macro = new output_class, name, level, device_options, message_transformer
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
      transformer = self.message_transformer
      device_options = self.device_options

      writer_attribute = Writer::Attribute.build name
      attribute_name = writer_attribute.name
      var_name = writer_attribute.variable_name

      output_class.send :define_method, attribute_name do
        writer = instance_variable_get var_name

        unless writer
          writer = build_writer(name, level, device_options, transformer) unless writer
          instance_variable_set var_name, writer
        end

        writer
      end
    end

    def define_setter
      writer_attribute = Writer::Attribute.build name
      attribute_name = writer_attribute.name
      var_name = writer_attribute.variable_name

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
        self.last_method = name
        message
      end
    end
  end
end

