require_relative '../proofs_init'

title 'Pushing An Appender To Output'

module PushingAnAppenderToOutputProofs
  class Example
    include Output

    level :info

    writer :first, :level => :debug
    writer :second, :level => :debug

    module Proof
      def appender?(appender)
        first_writer.appender?(appender) &&
        second_writer.appender?(appender)
      end
    end
  end
end


def new_appender
  Logging.appenders.string_io(:first)
end

def new_output
  logger = Logging::logger['First']
  logger.level = :debug

  PushingAnAppenderToOutputProofs::Example.new
end

heading 'Pushing an appender' do
  proof 'Pushes it to all of its writers' do
    appender = new_appender
    output = new_output

    output.push_appender appender
    output.prove { appender? appender }
  end
end

heading 'Pushing an appender with a block' do
  appender = new_appender

  proof 'Pushes it to all of the writers appenders' do
    output = new_output

    output.push_appender appender

    output.prove { appender? appender }
  end

  proof 'Pops the appender from all of its writers after the block has run' do
    output = new_output

    output.push_appender appender do
    end

    output.prove { !appender?(appender) }
  end
end
