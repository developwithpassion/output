require_relative '../proofs_init'
require_relative 'builders'

include OutputProofs

title 'Pushing A Device To A Writer'

module Output
  class Writer
    module Proof
      def devices?(device, occurences)
        devices.include?(device) &&
          devices.count == occurences
      end

      def logger_devices?(device, occurences)
        @logger.appenders.include?(device) &&
          @logger.appenders.select{|item| item == device}.count == occurences
      end

    end
  end
end

module Logging
  class Appender
    def attributes_match?(options)
      self.layout.pattern = options[:pattern]
    end
  end
end

def device
  Builders.device
end

def writer
  Builders.writer
end

heading 'Pushing an device' do
  dvc = device
  wrt = writer

  wrt.push_device dvc

  proof do
    desc "Device is added to its pushed devices"
    wrt.prove { device? dvc }

    desc "Device is added to its logger's devices"
    wrt.prove { logger_device? dvc }
  end
end


heading 'Pushing an device with a block' do
  dvc = device
  wrt = writer

  proof do

    wrt.push_device dvc do
      desc 'Device is added to its pushed devices'
      wrt.prove { device? dvc }

      desc 'Device is added to its loggers devices'
      wrt.prove { logger_device? dvc }
    end

    desc 'Device is removed from its pushed devices after running the block'
    wrt.prove { !device? dvc }

    desc 'Device is removed from its loggers devices after running the block'
    wrt.prove { !logger_device? dvc }

  end
end

heading 'Pushing an device using default options' do
  proof do
    wrt = writer

    dvc = wrt.push_device :string_io, :name => :pushing_with_options do
      desc 'Block is run'
      wrt.prove { true }
    end

    desc 'Device is removed from its pushed devices after running the block'
    wrt.prove { !device? dvc }

    desc 'Device is removed from its loggers devices after running the block'
    wrt.prove { !logger_device? dvc }
  end
end

heading 'Pushing an device using options' do
  proof do
    wrt = writer
    pattern = '%m %m \n'
    new_options = { :pattern => pattern, :name => :some_name }
    dvc = wrt.push_device :string_io, new_options

    desc 'Device options are initialized from options' 
    dvc.prove { attributes_match? new_options }
  end

  proof 'Fails if attempting to push multiple devices with the same options' do
    wrt = writer
    failed = false
    name = :duplicated_name_for_fails_if_attempting_more_than_once
    options = { :name => name }

    dvc = wrt.push_device :string_io, options
    begin
      second = wrt.push_device :string_io, options
    rescue
      failed = true
    end
    failed.prove { failed }
  end
end

