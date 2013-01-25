require_relative '../proofs_init'
require 'ostruct'

title "Writer Macro"

module Macro
  class Output
    include ::Output
  end
end

module Output
  class WriterMacro
    module Proof
      def attribute_properties?(name, properties)
        properties == self.class.attribute_properties(name)
      end

      def getter?(name)
        output_class.method_defined? name
      end

      def setter?(name)
        output_class.method_defined? :"#{name}="
      end

      def writes?(name)
        output_class.method_defined? name
      end

      def gets?(name, writer)
        output = Macro::Output.new

        output_writer = output.instance_variable_get :@something_writer
        output.instance_variable_set :@something_writer, writer

        proven = output.send(name) == writer

        output.instance_variable_set :@something_writer, output_writer

        proven
      end

      def sets?(name, writer)
        output = Macro::Output.new

        output_writer = output.instance_variable_get :@something_writer

        output.send :"#{name}=", writer
        proven = output.instance_variable_get(:"@#{name}") == writer

        output.instance_variable_set :@something_writer, output_writer

        proven
      end

      def created_lazily?(name)
        define_getter

        output = Macro::Output.new

        output_writer = output.instance_variable_get :"@#{name}"
        output.instance_variable_set :"@#{name}", nil

        output.send name

        presently = output.instance_variable_get("@#{name}")

        proven = !presently.nil?

        output.instance_variable_set :@something_writer, output_writer

        proven
      end
    end
  end
end

macro = Output::WriterMacro.new Macro::Output, :something, :debug, ->(text) {text}

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

proof "Defines the write method for the writer" do
  macro.define_write_method
  macro.prove { writes? :something }
end

proof "Access to writers is provided by their getters" do
  some_writer = OpenStruct.new
  macro.prove { gets? :something_writer, some_writer }
end

proof "Writers are assigned lazily upon access of their getters" do
  macro.prove { created_lazily? :something_writer }
end

proof "Assignment of writers is provided by their setters" do
  some_writer = OpenStruct.new
  macro.prove { sets? :something_writer, some_writer }
end
