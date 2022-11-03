# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'nymeria'
  s.version     = '2.0.7'
  s.summary     = 'Easily interact with Nymeria\'s API to find and verify people\'s contact information.'
  s.description = 'Nymeria enables people to easily discover and connect with people. This gem is a light weight wrapper around Nymeria\'s API. With this gem you can easily interact with the API to find and verify people\'s contact information.'
  s.authors     = ['Nymeria, LLC']
  s.email       = 'dev@nymeria.io'
  s.files       = `git ls-files -z`.split("\x0")
  s.require_paths = ['lib']
  s.homepage    = 'https://www.nymeria.io'
  s.metadata    = { "source_code_uri" => "https://git.nymeria.io/nymeria.rb" }
  s.license     = 'MIT'
end
