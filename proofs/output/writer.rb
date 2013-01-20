require_relative '../proofs_init'

def create_writer
  logger = Object.new
  default_level = :info
  
  ::Output::Writer.new logger,default_level
end

proof 'A Writer is initially enabled' do
  writer = create_writer

  writer.prove { enabled? }
end

proof ''
