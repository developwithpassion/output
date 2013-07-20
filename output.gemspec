# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'output'
  s.summary = 'Output Library'
  s.version = '0.0.2'
  s.authors = ['The Sans Collective']
  s.homepage = 'https://github.com/Sans/output'
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9.2'
  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')

  s.add_dependency 'logging'
  s.add_dependency 'initializer'
  s.add_dependency 'extension'
end
