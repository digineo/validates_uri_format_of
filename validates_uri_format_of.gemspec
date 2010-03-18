Gem::Specification.new do |s|
  s.name = %q{validates_uri_format_of}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
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
  s.has_rdoc         = true
  s.homepage         = %q{http://github.com/digineo/validates_uri_format_of}
  s.rdoc_options     = ["--inline-source", "--charset=UTF-8"]
  s.require_paths    = ["lib"]
  s.requirements     = %s(rmagick libqt4-ruby libqt4-webkit)
  s.rubygems_version = %q{1.3.0}
  
  s.add_dependency("activerecord", [">= 2.3"])
  # s.add_development_dependency('rspec')
  
end
