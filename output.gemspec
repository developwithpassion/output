# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'build/version'

Gem::Specification.new do |s|
  s.name = 'output'
  s.summary = 'Output Library'
  s.version = Output::VERSION
  s.authors = 'We made this'
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9.2'
  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
end
