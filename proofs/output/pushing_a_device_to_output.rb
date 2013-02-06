require_relative '../proofs_init'

title 'Pushing An Device To Output'

module PushingAnDeviceToOutputProofs
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


def new_device
  Logging.appenders.string_io(:first)
end

def new_output
  logger = Logging::logger['First']
  logger.level = :debug

  PushingAnDeviceToOutputProofs::Example.new
end

heading 'Pushing a device' do
  proof 'Pushes it to all of its writers' do
    device = new_device
    output = new_output

    output.push_device device
    output.prove { device? device }
  end
end


heading 'Pushing a device with a block' do
  device = new_device

  proof 'Pushes it to all of the writers devices' do
    output = new_output

    output.push_device device

    output.prove { device? device }
  end

  proof 'Pops the device from all of its writers after the block has run' do
    output = new_output

    output.push_device device do
    end

    output.prove { !device?(device) }
  end
end

heading 'Pushing a device using options' do
  proof 'Pushes the device to all of its writers' do
    output = new_output

    device = output.push_device_from_opts(:string_io)

    output.prove { device? device }
  end

  proof 'Runs a block if provided' do
    output = new_output
    ran = false

    device = output.push_device_from_opts(:string_io) do
      ran = true
    end

    ran.prove { self == true }
  end
  proof 'Pops the device from all of its writers after block is run' do
    output = new_output

    device = output.push_device_from_opts(:string_io) do
    end

    output.prove { not device? device }

  end
end
