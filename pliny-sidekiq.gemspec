# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pliny/sidekiq/version'

Gem::Specification.new do |spec|
  spec.name          = "pliny-sidekiq"
  spec.version       = Pliny::Sidekiq::VERSION
  spec.license       = 'MIT'
  spec.authors       = ["Guðmundur Bjarni Ólafsson"]
  spec.email         = ["gudmundur.bjarni@gmail.com"]

  spec.summary       = %q{Pliny logging and request_id support for Sidekiq}
  spec.description   = %q{Pliny logging and request_id support for Sidekiq}
  spec.homepage      = "https://github.com/gudmundur/pliny-sidekiq"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "pliny", ">= 0.18.0"
  spec.add_dependency "sidekiq", "<= 7.0.0"

  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
