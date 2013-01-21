module Output
  module WriterCreation
    def self.included(base)
      base.extend ClassMethods
    end

    # TODO what's this idiom?
    # What happens when both object and class use this module
    # ie: can be included AND extended
    # def self.extended(base)
    #   base.extend ClassMethods
    # end

    module ClassMethods
      def writers
        @writers ||= [].extend Writers
      end

      def define_write_method(name, writer_accessor_name, level, transform)
        # TODO lift to same name
        all_writers = writers

        send :define_method, name do |message|
          message = transform.call message
          writer = send writer_accessor_name

          # TODO write method also has responsibility of registering the writer?
          # No, this logic is purely a concern of creation-time, not run-time
          all_writers << writer unless all_writers.include? writer
          #

          writer.write level, message
          message
        end

      end

      def writer(name, options = {}, &transform_block)
        transform = transform_block || ->(message) { message } 
        level = options.fetch(:level, :debug)
        writer_accessor_name = "#{name}_writer"

        # TODO Optional, only if is a setting (and make sure consts are defined before checking if is a #{const})
        setting writer_accessor_name

        define_write_method name, 
                            writer_accessor_name, 
                            level, 
                            transform
      end
    end
  end
end
