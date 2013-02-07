require_relative '../proofs_init'

title 'Pushing Output Levels'

module PushingOutputLevelsProofs
  class Output
    include ::Output

    level :fatal
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
  PushingOutputLevelsProofs::Output.new
end

heading 'When a level is pushed' do
  proof 'Writers at or below the level should be able to write' do
    otp = output

    otp.push_level :info
    otp.info "This should write"

    contents = otp.info_writer.logger.appenders[0].read
    contents.prove { self.match "This should write" }
  end
end

heading 'When multiple levels are pushed' do
  proof 'Only the most recently pushed level is active' do
    otp = output

    otp.push_level :info
    otp.push_level :fatal
    otp.info "This should not write"

    contents = otp.info_writer.logger.appenders[0].read
    contents.prove { self == "" }
  end
end

heading 'When pushing a level and a block is provided' do
  proof 'Writers at or below the level should be able to write' do
    otp = output

    otp.push_level :info do
      otp.info "This should write"
    end

    contents = otp.info_writer.logger.appenders[0].read
    contents.prove { self.match "This should write" }
  end

  proof 'Output goes back to its previous level after the block runs' do
    otp = output
    level_before_push = otp.level

    otp.push_level :info do
      otp.info "This should write"
    end

    otp.prove { level? level_before_push }
  end
end
