require_relative '../proofs_init'
require_relative '../example/builders'

include OutputProofs

title 'Adding An Device To A Writer'

module Output
  class Writer
    module Proof
      def device?(device)
        devices.include?(device)
      end

      def logger_device?(device)
        @logger.appenders.include?(device)
      end
    end
  end
end

heading "Adding a device" do

  proof "Adds the device to its logger's devices" do
    wrt = Builders.writer
    new_device =  Builders.device

    wrt.add_device new_device

    wrt.prove { logger_device? new_device }
  end
end
