require_relative '../proofs_init'
require 'ostruct'

title "Writer Macro"

module WriterMacroProofs
  class Output
    include ::Output
  end
end

module Output
  class WriterMacro
    module Proof
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
        output = WriterMacroProofs::Output.new

        output_writer = output.instance_variable_get :@something_writer
        output.instance_variable_set :@something_writer, writer

        proven = output.send(name) == writer

        output.instance_variable_set :@something_writer, output_writer

        proven
      end

      def sets?(name, writer)
        output = WriterMacroProofs::Output.new

        output_writer = output.instance_variable_get :@something_writer

        output.send :"#{name}=", writer
        proven = output.instance_variable_get(:"@#{name}") == writer

        output.instance_variable_set :@something_writer, output_writer

        proven
      end

      def created_lazily?(name)
        define_getter

        output = WriterMacroProofs::Output.new

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

def macro
  macro = Output::WriterMacro.new WriterMacroProofs::Output, :something, :debug, WriterMacroProofs::Output::build_device_options, ->(text) {text}
end

proof "Defines a getter for the writer" do
  mcr = macro

  mcr.define_getter
  mcr.prove { getter? :something_writer }
end

proof "Defines a setter for the writer" do
  mcr = macro

  mcr.define_setter
  mcr.prove { setter? :something_writer }
end

proof "Defines the write method for the writer" do
  mcr = macro

  mcr.define_write_method
  mcr.prove { writes? :something }
end

proof "Access to writers is provided by their getters" do
  mcr = macro

  some_writer = OpenStruct.new
  mcr.prove { gets? :something_writer, some_writer }
end

proof "Writers are assigned lazily upon access of their getters" do
  mcr = macro

  mcr.prove { created_lazily? :something_writer }
end

proof "Assignment of writers is provided by their setters" do
  mcr = macro

  some_writer = OpenStruct.new
  mcr.prove { sets? :something_writer, some_writer }
end
