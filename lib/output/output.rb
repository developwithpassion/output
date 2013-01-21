module Output
  def self.included(base)
    base.extend ClassMethods
  end

  def write(method, description)
    send method, description
  end

  def self.disable
    writers.disable
  end

  def self.level=
    writers.disable
  end

  module ClassMethods
    def writers
      @writers ||= [].extend Writers
    end

    def writer(name, options = {}, &transform_block)
      transform = transform_block || ->(message) { message } 

      level = options.fetch(:level, name)

      define_writer_accessor name

      logger = logger(name)
      writer = Writer.new(logger, level)

      define_write_method name, 
                    writer,
                    transform

      writers << writer
    end

    def define_writer_accessor(name)
      accessor_name = "#{name}_writer"
      setting accessor_name
    end

    def logger(name)
      logger = Logging.logger name.to_s

      layout = Logging.layouts.pattern(:pattern => '%m\n')
      stdout_appender = Logging::Appenders::Stdout.new('stdout', :layout => layout)

      logger.appenders = stdout_appender

      logger
    end

    def define_write_method(name, writer, transform)
      send :define_method, name do |message|
        message = transform.call message
        writer.write message
        message
      end
    end
  end
end
