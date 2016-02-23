# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sigaa_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "sigaa_parser"
  spec.version       = SigaaParser::VERSION
  spec.authors       = ["Fernando Brito"]
  spec.email         = ["email@fernandobrito.com"]

  spec.summary       = %q{Gem to scrap and parse the academic web system (SIGAA) used at UFPB.}
  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/fernandobrito/sigaa_parser"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'mechanize', '~> 2.7'
  spec.add_dependency 'activesupport', '~> 4.2'
  spec.add_dependency 'dotenv', '~> 2.1'
  spec.add_dependency 'watir-webdriver'

  spec.add_development_dependency 'launchy', '~> 2.4'
  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-remote'
  spec.add_development_dependency 'pry-nav'
  spec.add_development_dependency 'simplecov'
end
