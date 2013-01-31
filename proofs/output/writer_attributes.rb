require_relative '../proofs_init'

title 'Writer Attributes'

def writer_attribute_properties
  writer_name = :something
  Output::Writer::Naming.attribute_properties(writer_name)
end

proof 'Format of writer attribute name is: "{name}_writer"' do
  attribute_name, variable_name = writer_attribute_properties
  attribute_name.prove { self == :something_writer }
end

proof 'Format of writer variable name is: "@{name}_writer"' do
  attribute_name, variable_name = writer_attribute_properties
  variable_name.prove { self == :@something_writer }
end
