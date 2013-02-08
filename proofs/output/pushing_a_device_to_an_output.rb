require_relative '../proofs_init'
require_relative 'builders'

include OutputProofs

title 'Pushing A Device To An Output'

module PushingADeviceToOutputProofs
  class Example
    include Output

    level :info

    writer :first, :level => :debug
    writer :second, :level => :debug

    module Proof
      def device?(device)
        first_writer.device?(device) &&
          second_writer.device?(device)
      end

    end
  end
end


def device
  Builders.device
end

def output
  PushingADeviceToOutputProofs::Example.new
end

heading 'Pushing a device' do
  proof 'Pushes it to all of its writers' do
    dvc = device
    opt = output

    opt.push_device dvc
    opt.prove { device? dvc }
  end

  proof 'Fails to push the same device multiple times' do
    opt = output

    opt.push_device :string_io
    begin
      opt.push_device :string_io
      opt.prove { false }
    rescue
      opt.prove { true }
    end
  end
end


heading 'Pushing a device with a block' do
  proof  do
    dvc = device
    opt = output

    opt.push_device dvc do
      desc 'Pushes it to all of the writers devices'
      opt.prove { device? dvc }
    end

    desc 'Pops the device from all of its writers after the block has run'
    opt.prove { !device?(dvc) }
  end
end

heading 'Pushing a device using options' do
  proof 'Pushes the device to all of its writers' do
    opt = output
    dvc = opt.push_device(:string_io)

    desc 'Pushes the device to all of its writers'
    opt.prove { device? dvc }
  end

  proof 'Runs a block if provided' do
    opt = output
    ran = false

    dvc = opt.push_device(:string_io) do
      opt.prove { true }
    end
  end
  proof 'Pops the device from all of its writers after block is run' do
    opt = output

    dvc = opt.push_device(:string_io) do
    end

    opt.prove { not device? dvc }

  end
end
