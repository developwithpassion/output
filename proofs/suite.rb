require_relative 'proofs_init'

files = Dir.glob("output/**/*.rb").reject do|item| 
  /_sketch/ =~ item
end

Proof::Runner::Suite.run files, "demos/**/*.rb"
