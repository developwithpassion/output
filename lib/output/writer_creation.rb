module Output
  module WriterCreation
    def self.included(base)
      base.extend ClassMethods
    end
    def self.extended(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def writers
        @writers ||= [].extend Writers
      end

      def define_write_method(name, writer_accessor_name, level, transform)
        all_writers = writers

        send :define_method, name do |message|
          message = transform.call message
          writer = send writer_accessor_name
          all_writers << writer unless all_writers.include? writer
          writer.write level, message
          message
        end
      end

      def writer(name,options = {}, &transform_block)
        transform = transform_block || ->(message) { message } 
        level = options.fetch(:level,:debug)
        writer_accessor_name = "#{name}_logger"

        setting writer_accessor_name

        define_write_method name, 
                            writer_accessor_name, 
                            level, 
                            transform
      end
    end
  end
end
