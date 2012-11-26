# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_doctor/version'

Gem::Specification.new do |gem|
  gem.name          = "rails_doctor"
  gem.version       = RailsDoctor::VERSION
  gem.authors       = ["Dmitry Gruzd"]
  gem.email         = ["donotsendhere@gmail.com"]
  gem.description   = %q{ gem detect problems in your rails project}
  gem.summary       = %q{ rails_doctor gem that can help you to find errors in different ways e.g. if you forgot to add indexes on association column}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rspec'
end
