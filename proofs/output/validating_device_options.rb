require_relative '../proofs_init'

title 'Validating Device Options'

class Hash
  module Proof
    def invalid?(&block)
      error = nil
      begin
        yield
      rescue => error
      end
      not error.nil?
    end
  end
end

def options(options = {})
  options.extend Output::Devices::OptionValidation
end

proof 'Validation fails if options are not valid' do
  options = options(:layout => 'layout')

  options.prove { invalid? { validate!(:stdout, :layout) }}
end


