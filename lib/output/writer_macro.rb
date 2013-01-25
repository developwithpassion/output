module Output
  class WriterMacro
    attr_reader :output_class
    attr_reader :name
    attr_reader :level
    attr_reader :message_transformer

    def initialize(output_class, name, level, message_transformer=nil)
      @output_class = output_class
      @name = name
      @level = level
      @message_transformer = message_transformer
    end

    def define_writer_accessor
      define_getter
      define_setter
    end

    def define_getter
      name = self.name
      level = self.level
      message_transformer = self.message_transformer

      attribute_name, var_name = self.class.attribute_properties(name)

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
      attribute_name, var_name = self.class.attribute_properties(name)

      output_class.send :define_method, "#{attribute_name}=" do |writer|
        writer.logger_level = level
        instance_variable_set var_name, writer
        writer
      end
    end

    def self.attribute_properties(name)
      attribute_name = :"#{name}_writer"
      var_name = :"@#{attribute_name}"
      return attribute_name, var_name
    end
  end
end

