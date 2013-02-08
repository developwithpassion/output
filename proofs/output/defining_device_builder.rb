require_relative '../proofs_init'

title "Defining Device Builder"

module DefiningDeviceBuilderProofs
  class Example
    include Output::Devices::Builder

    required_options :pattern, :filename

    module Proof
      def required?(*keys)
        keys.all? do |key|
          all_required_options.include?(key)
        end
      end

      def device_id?(id)
        device_id == id
      end
    end
  end
end

def example
  DefiningDeviceBuilderProofs::Example
end

proof 'Stores list of required options' do
  example.prove { required? :pattern, :filename } 
end

proof 'Stores logging device class' do
  example.prove { device_id? :stdout }
end

