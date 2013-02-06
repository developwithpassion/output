module Output
  module Appenders
    def self.build_appender(name, appender_options)
      builders = { 
        :stdout => Builder::Stdout,
        :string_io => Builder::StringIo,
        :file => Builder::File,
      }
      builder = builders[appender_options[:appender]]
      builder.build(name, appender_options)
    end

    module Builder
      def layout(pattern = '%m\n')
        Logging.layouts.pattern(:pattern => pattern)
      end


      def build(name, options)
        pattern = options[:pattern]
        layout = self.layout(pattern)
        options = { :layout => layout }.merge(options)

        Logging.appenders.send self.class.appender_id, name, options
      end

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def all_required_options
          @all_required_options ||= []
        end

        def required_options=(*options)
          @all_required_options = options
        end
        alias :required_options :required_options=

        def appender_id=(appender_id)
          @appender_id = appender_id
        end
        alias :appender :appender_id=

        def appender_id
          @appender_id ||= Output::DEFAULT_APPENDER
        end

        def build(name, options)
          options.extend Output::Appenders::OptionValidation
          options.validate!(appender_id, all_required_options)

          instance = new 
          instance.build(name, options)
        end
      end

      class StringIo
        include Builder

        appender :string_io
        required_options :pattern
      end

      class File
        include Builder

        appender :rolling_file
        required_options :filename, :pattern
      end

      class Stdout
        include Builder

        appender :stdout
        required_options :pattern
      end
    end

    module OptionValidation
      def validate!(appender_id, required = [])
        missing_option = false
        message = "An #{appender_id} appender requires :\n"
        required.each do |key|
          unless self.has_key?(key)
            missing_option = true
            message = "#{message}\t :#{key}\n" 
          end
        end
        raise message if missing_option
      end
    end
  end
end
