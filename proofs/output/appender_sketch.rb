require_relative '../proofs_init'

module Sketch
  class Output
    include ::Output

    level :info
    device :stdout
    pattern '...'
    file '...'
    color_scheme { :ssad => :dasds }

    writer :stdout, :level => :debug
    writer :foo, :level => :debug, :appender => :stdout, :pattern => '[%d] %-5l %c: %m\n'
    writer :stderr, :level => :debug, :appender => :stderr
    writer :string_io, :level => :debug, :appender => :string_io
    writer :file, :level => :debug, :appender => :file, :filename => 'foo/bar.txt'
  end
end

#

Outut::Appenders.string_io('%m\n')

#

writer.push_appender(:string_io, '%m\n')
writer.push_appender(:string_io) # => pattern is defaulted to '%m\n'

#

writer.push_appender__obj
writer.push_appender__spec

#

writer.push_appender appender
writer.push_appender Outut::Appenders.string_io('%m\n')

writer.write 'foos'
writer.pop_appender




writer :foo, :level => :debug, :appender => :stdout, :pattern => '[%d] %-5l %c: %m\n'
writer.push_appender(:string_io)

