require_relative '../proofs_init'

title 'Suspending devices on Output'

module SuspendingDevicesOnOutput
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
  Output::Devices.build_device(:stdout, :name => :some_name, :pattern => '%m\n') 
end

def output
  SuspendingDevicesOnOutput::Example.new
end

heading 'By instance' do
  proof 'Removes the device from all of its writers' do
    dvc = device
    opt = output

    opt.push_device dvc

    opt.suspend_devices dvc do
      opt.prove { not device? dvc }
    end
  end

  proof 'Runs the block provided' do
    dvc = device
    opt = output

    opt.push_device dvc

    opt.suspend_devices dvc do
      opt.prove { true }
    end
  end

  proof 'Adds the device back to all of its writers after the block has run' do
    dvc = device
    opt = output

    opt.push_device dvc

    opt.suspend_devices dvc do
      opt.prove { true }
    end

    opt.prove { device? dvc }
  end
end
heading 'By name' do
  proof 'Removes the device from all of its writers' do
    dvc = device
    opt = output

    opt.push_device dvc

    opt.suspend_devices :some_name do
      opt.prove { not device? dvc }
    end
  end

  proof 'Runs the block provided' do
    dvc = device
    opt = output

    opt.push_device dvc

    opt.suspend_devices :some_name do
      opt.prove { true }
    end
  end

  proof 'Adds the device back to all of its writers after the block has run' do
    dvc = device
    opt = output

    opt.push_device dvc

    opt.suspend_devices :some_name do
    end

    opt.prove { device? dvc }
  end
end
