require_relative '../proofs_init'
require_relative '../example/builders'

include OutputProofs

title "Device Suspension"

def suspension(writer, device)
  Output::Writer::DeviceSuspension.new(writer, device)
end

heading 'Suspending a device that is one of the writers pushed devices' do
  proof do
    wrt = Builders.writer
    dvc = Builders.device
    wrt.push_device dvc

    susp = suspension(wrt, dvc)
    susp.suspend

    desc "Removes the device from the writer's logger's devices"
    wrt.prove { not logger_device? dvc }

    desc "Removes the device from the writer's pushed devices"
    wrt.prove { not device? dvc }
  end
end

heading "Suspending a device that is only a writer's logger's device" do
  proof do
    wrt = Builders.writer
    dvc = Builders.device
    wrt.add_device dvc

    susp = suspension(wrt, dvc)
    susp.suspend

    desc "Removes the device from the writer's logger's devices"
    wrt.prove { not logger_device? dvc }

  end
end

heading "Suspending a device that not in the writer's pushed devices or its logger's devices" do
  proof do
    wrt = Builders.writer
    dvc = Builders.device
    logger_device = Builders.device
    pushed_device = Builders.device
    wrt.push_device pushed_device
    wrt.add_device logger_device

    susp = suspension(wrt, dvc)
    susp.suspend

    desc "Does not affect the state of the writer's logger's devices"
    wrt.prove { logger_device?(logger_device) && logger_device?(pushed_device) }

    desc "Does not affect the state of the writer's pushed devices"
    wrt.prove { device?(pushed_device) }

  end
end

heading "Suspending a nil device" do
  proof do
    wrt = Builders.writer
    dvc = nil
    logger_device = Builders.device
    pushed_device = Builders.device
    wrt.push_device pushed_device
    wrt.add_device logger_device

    susp = suspension(wrt, dvc)
    susp.suspend

    desc "Does not affect the state of the writer's logger's devices"
    wrt.prove { logger_device?(logger_device) && logger_device?(pushed_device) }

    desc "Does not affect the state of the writer's pushed devices"
    wrt.prove { device?(pushed_device) }
  end
end

heading "Restoring a device that was one of the writers pushed devices" do
  proof do
    wrt = Builders.writer
    dvc = Builders.device
    wrt.push_device dvc

    susp = suspension(wrt, dvc)
    susp.suspend
    
    susp.restore

    desc "Adds the device back onto the writer's pushed devices"
    wrt.prove { device? dvc }

    desc "Adds the device back onto the writer's logger's devices"
    wrt.prove { logger_device? dvc }
  end
end

heading "Restoring a device that was only one of the writer's logger's devices" do
  proof do
    wrt = Builders.writer
    dvc = Builders.device
    wrt.add_device dvc

    susp = suspension(wrt, dvc)
    susp.suspend
    
    susp.restore

    desc "Does not adds the device back onto writer's pushed devices"
    wrt.prove { not device? dvc }

    desc "Adds the device back onto the writer's logger's devices"
    wrt.prove { logger_device? dvc }
  end
end

heading "Restoring a device that was neiter one of the writer's pushed devices or one of it's logger's devices" do
  proof do
    wrt = Builders.writer
    dvc = Builders.device

    susp = suspension(wrt, dvc)
    susp.suspend
    
    susp.restore

    desc "Does not add the device onto the writer's pushed devices"
    wrt.prove { not device? dvc }

    desc "Does not add the device to the writer's logger's devices"
    wrt.prove { not logger_device? dvc }
  end
end
