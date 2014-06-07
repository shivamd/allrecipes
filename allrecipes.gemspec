# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'allrecipes/version'

Gem::Specification.new do |spec|
  spec.name          = "allrecipes"
  spec.version       = Allrecipes::VERSION
  spec.authors       = ["shivamd"]
  spec.email         = ["daryananis@gmail.com"]
  spec.summary       = %q{A Ruby wrapper for allrecipes.com}
  spec.description   = %q{A Ruby wrapper for allrecipes.com. A simple interface to scrape recipes from allrecipes.com}
  spec.homepage      = "https://github.com/shivamd/allrecipes"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
