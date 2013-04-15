# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'resque/append/version'

Gem::Specification.new do |spec|
  spec.name          = "resque-append"
  spec.version       = Resque::Append::VERSION
  spec.authors       = ["Josh Lane"]
  spec.email         = ["me@joshualane.com"]
  spec.description   = %q{Resque plugin that prevents nested inline behavior}
  spec.summary       = %q{resque-append detects uses a Resque::Worker to process your queue inline. When a job is enqueued and the worker is currently processing, it appends the job to run after}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "resque", "~> 1.23"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
