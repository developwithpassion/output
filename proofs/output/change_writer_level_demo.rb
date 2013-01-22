require_relative '../proofs_init'

class SomeOutput
  include Output
  include Single
  include Setter::Settings

  level :info

  writer :details, :level => :debug
end

output = SomeOutput.instance
writer = output.details_writer

# Writer: debug
# Logger: debug
# => should write

# puts writer.logger.level # => :info
output.details "This doesn't write because the writer is :debug and the logger is :info"

# Goal
# Get logger to info, so writing at debug doesn't write

# Express: Only want system to write at info
# => means: all loggers set to info

output.level = :debug
# puts writer.logger.level
output.details "This writes because the writer is :debug and the logger is :debug"
