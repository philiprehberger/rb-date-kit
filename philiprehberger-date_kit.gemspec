# frozen_string_literal: true

require_relative 'lib/philiprehberger/date_kit/version'

Gem::Specification.new do |spec|
  spec.name          = 'philiprehberger-date_kit'
  spec.version       = Philiprehberger::DateKit::VERSION
  spec.authors       = ['Philip Rehberger']
  spec.email         = ['me@philiprehberger.com']

  spec.summary       = 'Date utilities for business days, relative expressions, and period calculations'
  spec.description   = 'Date utilities including business day counting and arithmetic, quarter boundaries, ' \
                       'weekend detection, and natural language relative date parsing.'
  spec.homepage      = 'https://github.com/philiprehberger/rb-date-kit'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri']          = spec.homepage
  spec.metadata['source_code_uri']       = spec.homepage
  spec.metadata['changelog_uri']         = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['bug_tracker_uri']       = "#{spec.homepage}/issues"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir['lib/**/*.rb', 'LICENSE', 'README.md', 'CHANGELOG.md']
  spec.require_paths = ['lib']
end
