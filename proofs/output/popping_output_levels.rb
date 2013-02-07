require_relative '../proofs_init'

title 'Popping Output Levels'

module PoppingOutputLevelsProofs
  class Output
    include ::Output

    level :debug
    device :string_io

    writer :info, :level => :info
    writer :fatal

    module Proof
      def level?(level)
        self.level == level
      end
    end
  end
end

def output
  PoppingOutputLevelsProofs::Output.new
end

heading 'When a level is popped and there are not other levels pushed' do
  proof 'Output goes back to its previous level after the block run' do
    otp = output
    otp.push_level :fatal
    level_before_pop = otp.level

    otp.pop_level

    otp.prove { level? :debug }
  end
end

heading 'When a level is popped and there are multiple pushed levels' do
  proof 'Output goes back to the previous pushed level' do
    otp = output
    otp.push_level :info
    otp.push_level :debug

    otp.pop_level

    otp.prove { level? :info }
  end
end

heading 'When there are no more levels to pop' do
  proof 'Output goes back to its initial level' do
    otp = output
    otp.push_level :info
    otp.push_level :debug

    otp.pop_level
    otp.pop_level
    otp.pop_level

    otp.prove { level? :debug }
  end
end
