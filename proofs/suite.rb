#!/usr/bin/env ruby

require_relative 'proofs_init'

include Proof

result = Proof::Suite.run "output/**/*.rb"

exit result == :success
