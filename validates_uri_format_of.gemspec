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
  
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.homepage         = %q{https://github.com/digineo/validates_uri_format_of}
  s.rdoc_options     = ["--inline-source", "--charset=UTF-8"]
  s.require_paths    = ["lib"]
  
  s.add_dependency("activerecord", [">= 2.3"])
end
