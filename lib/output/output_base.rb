module Output
  module OutputBase
    def self.included(base)
      base.send :include, Single
      base.send :include, Setter::Settings
      base.send :include, WriterCreation
    end

    def write(method, description)
      send method, description
    end

    def self.disable
      writers.disable
    end

    def self.level=
      writers.disable
    end
    # Messing around with a dispatch macro to not need to create wrapper methods
    # or modules
    # broadcast :disable do
    #   writers
    # end
  end
end
