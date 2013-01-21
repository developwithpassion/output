module Output
  module OutputBase
    def self.included(base)
      # TODO Remove. Single semantics is not related to output semantics
      # This is entirely a user's choice
      # base.send :include, Single
      #

      # TODO Remove. Single semantics is not related to output semantics
      # This is entirely a user's choice
      # An Output class must stand entirely on its own
      # A user of Output should not be made to worry about settings unless
      # he already knows about settings, and wants them
      base.send :include, Setter::Settings
      #

      base.send :include, WriterCreation
      # base.extend WriterCreation
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
