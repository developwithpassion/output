require_relative '../proofs_init'

title "Resetting A Writer's Level"

module ResettingAWritersLevelProofs
  class Example
    include ::Output

    level :info

    writer :info
  end
end
module Output
  class Writer
    module Proof
      def initial_logger_level?
        logger_level == level
      end
    end
  end
end

def writer
  ResettingAWritersLevelProofs::Example.new.info_writer
end

proof 'Sets its logger level to its initial level' do
  wrt = writer

  wrt.logger_level = :debug

  wrt.reset_level

  wrt.prove { initial_logger_level? }
end

