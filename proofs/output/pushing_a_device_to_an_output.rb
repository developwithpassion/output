require_relative '../proofs_init'

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
  Logging.appenders.string_io(:first)
end

def output
  logger = Logging::logger['First']
  logger.level = :debug

  PushingADeviceToOutputProofs::Example.new
end

heading 'Pushing a device' do
  proof 'Pushes it to all of its writers' do
    dvc = device
    opt = output

    opt.push_device dvc
    opt.prove { device? dvc }
  end
end


heading 'Pushing a device with a block' do
  dvc = device

  proof 'Pushes it to all of the writers devices' do
    opt = output

    opt.push_device dvc

    opt.prove { device? dvc }
  end

  proof 'Pops the device from all of its writers after the block has run' do
    opt = output

    opt.push_device dvc do
    end

    opt.prove { !device?(dvc) }
  end
end

heading 'Pushing a device using options' do
  proof 'Pushes the device to all of its writers' do
    opt = output

    dvc = opt.push_device(:string_io)

    opt.prove { device? dvc }
  end

  proof 'Runs a block if provided' do
    opt = output
    ran = false

    dvc = opt.push_device(:string_io) do
      ran = true
    end

    ran.prove { self == true }
  end
  proof 'Pops the device from all of its writers after block is run' do
    opt = output

    dvc = opt.push_device(:string_io) do
    end

    opt.prove { not device? dvc }

  end
end
