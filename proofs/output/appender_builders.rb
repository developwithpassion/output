require_relative '../proofs_init'

title "Appender Builders"

module AppenderBuildersProofs
  class Example
    include Output::Appenders::Builder

    appender :stdout
    required_options :pattern, :filename

  end
end

def example
  AppenderBuildersProofs::Example
end

proof "Fails if all required options are not provided" do
  verification_error = nil
  begin
    example.build(:some_name, :pattern => '%m\n') 
  rescue => e
     verification_error = e
  end
  verification_error.prove { not nil? }
end

proof "Build using name and options" do
  options = { :pattern => '%m\n', :filename => 'blah' }
  result = example.build(:some_name, options)
  result.prove { not nil? }
end
