require_relative '../proofs_init'

title "Resetting An Output's Level"

module ResettingAnOutputsLevelProofs
  class Example
    include ::Output

    level :info

    writer :info
    writer :debug, :level => :debug

    module Proof
      def initial_logger_levels?
        each_writer do |writer|
          return false unless writer.initial_logger_level?
        end
        true
      end
    end
  end
end


def output
  ResettingAnOutputsLevelProofs::Example.new
end

proof 'Resets its level to its initial level' do
  otp = output  
  otp.level = :fatal

  otp.reset_level

  otp.prove { initial_level? }
end

proof 'Resets all of its writers' do
  otp = output

  otp.each_writer do |writer|
    writer.logger_level = :fatal
  end

  otp.reset_level

  otp.prove { initial_logger_levels? }
end

