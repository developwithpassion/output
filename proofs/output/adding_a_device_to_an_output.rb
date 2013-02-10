require_relative '../proofs_init'
require_relative '../example/builders'

include OutputProofs

title 'Adding An Device To An Output'

module AddingADeviceToAnOutputProofs
  class Output
    include ::Output

    writer :first
    writer :second
    
    module Proof
      def all_writers_have_device?(device)
        first_writer.logger_device?(device) &&
          second_writer.logger_device?(device)
      end
    end
  end
end

module Output
  class Writer
    module Proof
      def logger_device?(device)
        @logger.appenders.include?(device)
      end

    end
  end
end

def output
  AddingADeviceToAnOutputProofs::Output.new
end

proof do
  new_device =  Builders.device
  otp = output

  result = otp.add_device new_device

  desc 'Adds the device to all of its writers'
  otp.prove { all_writers_have_device? new_device }

  desc 'Return the device that was added'
  result.prove { self == new_device }
end

