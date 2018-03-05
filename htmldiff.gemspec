Gem::Specification.new do |s|
  s.name = %q{htmldiff}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nathan Herald"]
  s.autorequire = %q{htmldiff}
  s.date = %q{2008-11-21}
  s.description = %q{HTML diffs of text (borrowed from a wiki software I no longer remember)}
  s.email = %q{nathan@myobie.com}
  s.files = `git ls-files`.split($\)
  s.has_rdoc = true
  s.homepage = %q{http://github.com/myobie/htmldiff}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{HTML diffs of text (borrowed from a wiki software I no longer remember)}

  s.add_development_dependency "rspec", "~> 3.6"
  s.add_development_dependency "rake", "~> 12.1"
end
