require_relative '../proofs_init'

title 'Writer Attributes'

def writer_attribute(writer_name)
  Output::Writer::Attribute.build writer_name
end

module Output
  class Writer
    class Attribute
      module Proof
        def attribute_name?(attribute_name)
          self.name == attribute_name
        end
        def variable_name?(variable_name)
          self.variable_name == variable_name
        end
      end
    end
  end
end

proof 'Writer attribute name is the name of the writer suffixed with "_writer"' do
  writer_attribute(:something).prove { attribute_name? :something_writer }
end

proof 'Writer variable name is the name of the writer prefixed with "@" and suffixed with "_writer"' do
  writer_attribute(:something).prove { variable_name? :@something_writer }
end
