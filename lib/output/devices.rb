module Output
  module Devices
    def self.build_device(type, options = {})
      builders = { 
        :stdout => Builder::Stdout,
        :string_io => Builder::StringIo,
        :file => Builder::File,
        :stderr => Builder::Stderr
      }

      default_options = { :name => type, :pattern => DEFAULT_PATTERN }
      options = default_options.merge(options)
      name = options[:name]

      builder = builders[type]
      builder.build(name, options)
    end

    module Builder
      def layout(pattern = Output::Devices::DEFAULT_PATTERN)
        Logging.layouts.pattern(:pattern => pattern)
      end

      def build(name, options)
        pattern = options[:pattern]
        layout = self.layout(pattern)
        options = { :layout => layout }.merge(options)

        Logging.appenders.send self.class.device_id, name, options
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

        def device_id=(device_id)
          @device_id = device_id
        end
        alias :device :device_id=

        def device_id
          @device_id ||= Output::DEFAULT_DEVICE
        end

        def build(name, options)
          Extension.! options, Output::Devices::OptionValidation
          options.validate!(device_id, all_required_options)

          instance = new 
          instance.build(name, options)
        end
      end

      class StringIo
        include Builder

        device :string_io
        required_options :pattern
      end

      class File
        include Builder

        device :rolling_file
        required_options :filename, :pattern
      end

      class Stdout
        include Builder

        device :stdout
        required_options :pattern
      end

      class Stderr
        include Builder

        device :stderr
        required_options :pattern
      end
    end

    module OptionValidation
      def validate!(device_id, required = [])
        missing_option = false
        message = "An #{device_id} device requires :\n"
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
