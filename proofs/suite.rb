require_relative 'proofs_init'

files = Dir.glob("output/**/*.rb").reject do |file| 
  /appender_sketch/ =~ file
end

Proof::Runner::Suite.run files, "demos/**/*.rb"
