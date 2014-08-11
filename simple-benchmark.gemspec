# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_benchmark/version'

Gem::Specification.new do |spec|
  spec.name          = "simple-benchmark"
  spec.version       = SimpleBenchmark::VERSION
  spec.authors       = ["Patrick Reagan"]
  spec.email         = ["reaganpr@gmail.com"]
  spec.summary       = %q{A simple benchmarking tool for Ruby apps.}
  spec.homepage      = "http://viget.com/extend"
  spec.license       = "MIT"

  spec.files         = Dir['lib/**/*.rb']
  spec.test_files    = Dir['spec/**/*.rb']
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
