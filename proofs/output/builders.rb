module OutputProofs
  module Builders
    extend self
      def device_options(options={})
        { :device => :stdout, :name => :first, :pattern => '%m\n' }.merge(options)
      end

      def device(type = :stdout, options={})
        Output::Devices.build_device(type, device_options.merge(options)) 
      end

      def writer(type = :stdout, options={})
        Output::Writer.build 'first', :debug, nil, :debug, nil, device_options(:device => type).merge(options)
      end
  end
end
