require_relative '../proofs_init'

title 'Writer Macro'

comment 'Adds writer parameters to list of writer parameters on the output class'
comment 'Writer parameters include its name, level, and transform block'
comment 'Define writer attribute'

class SomeOutput
  include Output
  include Single
  include Setter::Settings

  writer :some_writer, :level => :debug do |text|
    text
  end

  module Proof
    def writer_defined?(name)
      writer = self.class.writers[name]
      not writer.nil?
    end
  end
end

output = SomeOutput.instance

proof 'Writer definition is listed by name' do
  comment 'Get definition from the Output class for the writer'
  output.prove { writer_defined? :some_writer }
end

proof 'Writer level is defined' do
end

comment 'The parameters should have been found for the name'
comment 'The level should be checked'
comment 'The block should be checked'
