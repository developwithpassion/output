require_relative '../proofs_init'

title 'Writer Attributes'

proof 'Writer attributes are: the attribute name and the attribute variable' do
  writer_name = :something
  attribute_name, variable_name = Output::Writer::Naming.attribute_properties(writer_name)

  attribute_name.prove{ self == :something_writer }
  variable_name.prove{ self == :@something_writer }
end
