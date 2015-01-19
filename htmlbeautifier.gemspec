require File.expand_path("../lib/htmlbeautifier/version", __FILE__)

spec = Gem::Specification.new do |s|
  s.name              = "htmlbeautifier"
  s.version           = HtmlBeautifier::VERSION::STRING
  s.summary           = "HTML/ERB beautifier"
  s.description       = "A normaliser/beautifier for HTML that also understands embedded Ruby."
  s.author            = "Paul Battley"
  s.email             = "pbattley@gmail.com"
  s.homepage          = "http://github.com/threedaymonk/htmlbeautifier"
  s.license           = "MIT"

  s.has_rdoc          = true

  s.files             = %w(Rakefile README.md) + Dir.glob("{bin,test,lib}/**/*")
  s.executables       = Dir["bin/**"].map { |f| File.basename(f) }

  s.require_paths     = ["lib"]

  s.required_ruby_version = '>= 1.9.2'

  s.add_development_dependency "rake", "~> 0"
  s.add_development_dependency "rspec", "~> 3"
end

