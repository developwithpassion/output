require_relative '../proofs_init'
require_relative 'builders'

include OutputProofs

title 'Popping An Device From A Writer'

def device
  Builders.device
end

def writer
  Builders.writer
end


proof 'Removes it from the its pushed devices' do
  dvc = device
  wtr = writer
  wtr.push_device dvc

  wtr.pop_device

  wtr.prove { not device? dvc }
end

proof "Removes it from its logger's devices" do
  dvc = device
  wtr = writer
  wtr.push_device dvc

  wtr.pop_device

  wtr.prove { not logger_device? dvc }
end
