require_relative '../proofs_init'

title "Defining Appender Builder"

module DefiningAnAppenderBuilderProofs
  class Example
    include Output::Appenders::Builder

    required_options :pattern, :filename

    module Proof
      def required?(*keys)
        keys.all? do|key|
          all_required_options.include?(key)
        end
      end

      def appender_id?(id)
        appender_id == id
      end
    end
  end
end

def example
  DefiningAnAppenderBuilderProofs::Example
end

proof 'Stores list of required options' do
  example.prove { required? :pattern, :filename } 
end

proof 'Stores logging appender class' do
  example.prove { appender_id? :stdout }
end

