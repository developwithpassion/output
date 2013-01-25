require_relative '../proofs_init'

title 'Writer Definition'

message_transformer = ->(message) { message }

SomeOutput = Class.new do
  include Output
  include Single

  writer :something, :level => :debug, &message_transformer

  module Proof
    def definition(name)
      self.class.writer_definitions[name]
    end

    def writer_defined?(name)
      not definition(name).nil?
    end

    def name?(name)
      not definition(name).name.nil?
    end

    def level?(name, level)
      definition(name).level == level
    end

    def message_transformer?(name, block)
      definition(name).message_transformer == block
    end
  end
end

heading 'A writer definition is created by the writer macro'

output = SomeOutput.instance

proof 'Writer definition is listed by name' do
  output.prove { writer_defined? :something }
end

proof 'Name is part of the definition' do
  output.prove { name? :something }
end

proof 'Level is part of the definition' do
  output.prove { level? :something, :debug }
end

proof 'Message transformer is part of the definition' do
  output.prove { message_transformer? :something, message_transformer }
end
