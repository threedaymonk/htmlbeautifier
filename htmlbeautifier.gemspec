# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{htmlbeautifier}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Paul Battley"]
  s.date = %q{2009-06-19}
  s.default_executable = %q{htmlbeautifier}
  s.email = %q{pbattley@gmail.com}
  s.executables = ["htmlbeautifier"]
  s.extra_rdoc_files = ["README.txt"]
  s.files = ["Rakefile", "README.txt", "bin/htmlbeautifier", "test/html_beautifier_test_utilities.rb", "test/test_helper.rb", "test/test_html_beautifier_integration.rb", "test/test_html_beautifier_regression.rb", "test/test_parser.rb", "lib/htmlbeautifier", "lib/htmlbeautifier/beautifier.rb", "lib/htmlbeautifier/parser.rb", "lib/htmlbeautifier/version.rb", "lib/htmlbeautifier.rb"]
  s.homepage = %q{http://github.com/threedaymonk/htmlbeautifier}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{A normaliser/beautifier for HTML that also understands embedded Ruby.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
