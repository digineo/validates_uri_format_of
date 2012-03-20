# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name    = "validates_uri_format_of"
  s.version = "0.2.0"

  s.authors     = ["Julian Kornberger", "Averell"]
  s.date        = %q{2010-03-18}
  s.description = %q{Rails plugin that provides a validates_uri_format_of method to ActiveRecord models. URLs are validated by several options.}
  s.summary     = %q{URL Validation for ActiveRecord models.}
  s.email       = %q{github@digineo.de}
  s.extra_rdoc_files = ["README.md", "LICENSE"]
  s.files = %w(
    init.rb
    LICENSE
    README.md
    lib/validates_uri_format_of.rb
  )
  s.homepage         = %q{http://github.com/digineo/validates_uri_format_of}
  s.rdoc_options     = ["--inline-source", "--charset=UTF-8"]
  s.require_paths    = ["lib"]
  s.requirements     = %w(rmagick libqt4-ruby libqt4-webkit)
  
  s.add_dependency("activerecord", [">= 2.3"])
  # s.add_development_dependency('rspec')
  
end
