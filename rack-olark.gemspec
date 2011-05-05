Gem::Specification.new do |s|
  s.name        = "rack-olark"
  s.version     = ::File.read(::File.expand_path('../VERSION', __FILE__)).strip
  s.date        = ::Date.today.to_s
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Dan Poggi"]
  s.email       = ["dan.poggi@gmail.com"]
  s.homepage    = "https://github.com/dpoggi/rack-olark"
  s.summary     = %q{Rack middleware for embedding Olark.}
  s.description = %q{Rack middleware which injects the Olark JavaScript code before the end of the body of any HTML document being sent to the client. See README.md for details.}

  s.rubyforge_project = "rack-olark"

  s.add_dependency('rack', ['>= 1.2.2'])
  s.add_dependency('haml', ['>= 3.1.1'])

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
end
