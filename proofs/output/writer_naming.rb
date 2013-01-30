require_relative '../proofs_init'

title 'Writer Naming'

naming = Output::Writer::Naming

module MyOutput
  class Output
  end
end

proof "A writer's fully-qualified name is the writer's namespace, ending in the writer's name" do
  mod = MyOutput::Output
  writer_name = :something

  name = naming.fully_qualified(mod, writer_name)

  name.prove { self == "MyOutput::Output::Something"}
end

proof 'Writer name is camel-cased' do
  name = "this_Is_some_name"

  result = naming.camel_case(name)
  result.prove { self == 'ThisIsSomeName'}
end
