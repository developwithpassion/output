module Output
  module Writers
    def disable
      each do |writer|
        writer.disable
      end
    end

    def level=(new_level)
      each do |writer|
        writer.level = new_level
      end
    end
  end
end
