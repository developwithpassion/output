require_relative '../proofs_init'

title 'Writer Naming'

naming = Output::Writer::Naming

proof 'Camel casing works correctly' do
  name = "this_Is_some_name"

  result = naming.camel_case(name)
  result.prove { self == 'ThisIsSomeName'}
end


proof 'Builds appropriate names for writer attributes' do
  writer_name = :something
  attribute_name, variable_name = naming.attribute_properties(writer_name)

  attribute_name.prove{ self == :something_writer }
  variable_name.prove{ self == :@something_writer }
end

module MyOutput
  class Output

  end
end

proof 'Builds fully qualified names for writers' do
  mod = MyOutput::Output
  writer_name = :something

  name = naming.fully_qualified(mod, writer_name)

  name.prove { self == "MyOutput::Output::Something"}
end
