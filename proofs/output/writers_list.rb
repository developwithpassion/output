require_relative '../proofs_init'

title "Output's List of Writers"

module WritersList
  class Output
    include ::Output
    include Single

    writer :something
    writer :something_else

    module Proof
      def collected?(writers)
        return false unless self.writers.length == writers.length

        self.writers.each do |writer|
          return false unless writers.include? writer
        end
      end
    end
  end
end

heading "The list of writers is not held in the output object's state.\nThe writers are collected from the output object based on the output class's list of writer names."

output = WritersList::Output.instance

something_writer = Output::Writer.build :something
something_else_writer = Output::Writer.build :something_else

output.something_writer = something_writer
output.something_else_writer = something_else_writer

proof "Writers are collected" do
  writers = [something_writer, something_else_writer]
  output.prove { collected? writers }
end
