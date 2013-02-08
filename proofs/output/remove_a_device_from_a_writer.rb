require_relative '../proofs_init'
require_relative 'builders'

include OutputProofs

title 'Remove A Device From A Writer'

module Output
  class Writer
    module Proof
      def logger_device?(device)
        @logger.appenders.include?(device)
      end

    end
  end
end


def device
  Builders.device
end

def writer
  Builders.writer
end


proof "Remove the device from its logger's devices" do
  wrt = writer
  new_device =  device
  wrt.add_device new_device

  wrt.remove_device new_device

  wrt.prove { not logger_device? new_device }
end
