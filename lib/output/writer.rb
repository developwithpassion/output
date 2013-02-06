module Output
  class Writer
    include BuildLogger
    include Initializer

    attr_reader :name
    attr_accessor :level
    attr_reader :message_transformer
    attr_reader :enabled
    attr_writer :appenders

    initializer :name, :level, :message_transformer, :logger, :appender_options

    def self.build(writer_name, level=Output::DEFAULT_LOGGER_LEVEL, message_transformer=nil, logger_level=Output::DEFAULT_LOGGER_LEVEL, logger_name=nil, appender_options)
      logger_name ||= writer_name
      logger = build_logger(logger_name, logger_level, appender_options)
      writer = new(writer_name, level, message_transformer, logger, appender_options)
    end

    def appenders
      @appenders ||= []
    end

    def disable
      @enabled = false
    end

    def enable
      @enabled = true
    end

    def enabled?
      @enabled ||= true
    end

    def logger_level
      Util.level_name @logger.level
    end

    def logger_level=(level)
      @logger.level = level
    end

    def logger_name
      @logger.name
    end

    def write(message)
      message = message_transformer.call message if message_transformer
      @logger.send level, message if enabled?
    end

    def push_appender_obj(appender)
      return if appenders.include?(appender)
      appenders.push appender
      @logger.add_appenders(appender)
      if block_given?
        yield
        pop_appender
      end
      appender
    end
    alias :push_appender :push_appender_obj

    def push_appender_from_opts(appender_type, options = {}, &block)
      options = options.merge(:appender => appender_type)
      options = self.appender_options.merge(options)

      appender = Output::Appenders.build_appender(:anon, options)
      push_appender_obj appender, &block
    end

    def pop_appender
      return if appenders.count == 0
      appender = appenders.pop
      @logger.remove_appenders(appender)
    end

    def appender?(appender)
      appenders.include?(appender)
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

    module Util
      extend self

      def level_name(level_number)
        level_names = Logging::LNAMES
        level_name =  Logging::levelify level_names[level_number]
        level_name.to_sym
      end
    end
  end
end
