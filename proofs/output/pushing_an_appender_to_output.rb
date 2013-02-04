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
        result = true
        first_writer.prove do 
          result &&= appender?(appender) 
          true
        end
        second_writer.prove do 
          result &&= appender?(appender)
          true
        end
        result
      end
    end
  end
end

module Output
  class Writer
    module Proof
      def appender?(appender)
        extra_appenders.include?(appender) &&
          @logger.appenders.include?(appender)
      end
    end
  end
end

def new_output
  logger = Logging::logger['First']
  logger.level = :debug

  PushingAnAppenderToOutputProofs::Example.new
end

heading 'Pushing an appender' do
  proof 'Pushes it to all of its writers' do
    appender = Logging.appenders.file('output.log')
    output = new_output

    output.push_appender appender
    output.prove { appender? appender }
  end
end

heading 'Pushing an appender with a block' do
  proof 'Pushes it to all of the writers appenders' do
    appender = Logging.appenders.file('output.log')
    output = new_output

    output.push_appender appender
    output.prove { appender? appender }
  end

  proof 'Pops the appender from all of its writers after the block has run' do
    appender = Logging.appenders.file('output.log')
    output = new_output

    output.push_appender appender do
      output.prove { appender? appender }
    end
    output.prove { !appender?(appender) }
  end
end

