# coding: utf-8
lib = File.expand_path(File.join('..', 'lib'), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/olark/version'

Gem::Specification.new do |s|
  s.name        = 'rack-olark'
  s.license     = 'MIT'
  s.version     = Rack::Olark::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Dan Poggi']
  s.email       = ['dan.poggi@gmail.com']
  s.homepage    = 'https://github.com/dpoggi/rack-olark'
  s.summary     = %q{Rack middleware for inserting Olark JavaScript embed code.}
  s.description = %q{Middleware which inserts Olark JavaScript embed code before </body> in HTML served by Rack.}

  s.files         = Dir.glob(File.join('lib', '**', '*')).concat(%w(README.md LICENSE))
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.1.0'

  s.add_dependency 'rack', '>= 1.2.0'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'bundler'
end
