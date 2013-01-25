require_relative '../proofs_init'
require 'ostruct'

title "Writer Macro"

module Macro
  class Output
    include ::Output
    include Single

    module Proof
      def writer_getter?(name)
        respond_to? name
      end
    end
  end
end

module Output
  class WriterMacro
    module Proof
      def attribute_properties?(name, properties)
        properties == self.class.attribute_properties(name)
      end

      def getter?(name)
        output.respond_to? name
      end

      def setter?(name)
        output.respond_to? :"#{name}="
      end

      def gets?(name, writer)
        output.send(name) == writer
      end

      def created_lazily?(name)
        define_getter
        originally = output.instance_variable_get(:"@#{name}")
        output.send name
        presently = output.instance_variable_get("@#{name}")
        originally.nil? and not presently.nil?
      end
    end
  end
end

output = Macro::Output.instance
macro = Output::WriterMacro.new output, :something, :debug, ->(text) {text}

proof "Attribute's properties are it's name and the backing variable name" do
  macro.prove { attribute_properties? :something, [:something_writer, :@something_writer] }
end

proof "Defines a getter for the writer" do
  macro.define_getter
  macro.prove { getter? :something_writer }
end

proof "Defines a setter for the writer" do
  macro.define_setter
  macro.prove { setter? :something_writer }
end

proof "Access to writers is provided by their getters" do
  output_writer = output.instance_variable_get :@something_writer

  some_writer = OpenStruct.new
  output.instance_variable_set :@something_writer, some_writer

  macro.prove { gets? :something_writer, some_writer }

  output.instance_variable_set :@something_writer, output_writer
end

proof "Writers are created lazily upon access of their getters" do
  output_writer = output.instance_variable_get :@something_writer

  output.instance_variable_set :@something_writer, nil
  macro.prove { created_lazily? :something_writer }

  output.instance_variable_set :@something_writer, output_writer
end
