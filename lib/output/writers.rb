module Output
  module Writers
    def disable
      each do |writer|
        writer.disable
      end
    end

    def level=(level)
      each do |writer|
        writer.level = level
      end
    end

    def logger_level=(level)
      each do |writer|
        writer.logger.level = level
      end
    end
  end
end
