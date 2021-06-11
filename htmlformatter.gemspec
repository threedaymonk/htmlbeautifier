require File.expand_path("../lib/htmlformatter/version", __FILE__)

spec = Gem::Specification.new do |s|
  s.name              = "htmlformatter"
  s.version           = HtmlFormatter::VERSION::STRING
  s.summary           = "HTML/ERB/EEX formatter"
  s.description       = "A normaliser/formatter for HTML that also understands embedded Ruby and Elixir."
  s.authors           = ["Paul Battley", "Bartosz Kalinowski"]
  s.email             = "kelostrada@gmail.com"
  s.homepage          = "http://github.com/kelostrada/htmlformatter"
  s.license           = "MIT"

  s.files             = %w(Rakefile README.md) + Dir.glob("{bin,test,lib}/**/*")
  s.executables       = Dir["bin/**"].map { |f| File.basename(f) }

  s.require_paths     = ["lib"]

  s.required_ruby_version = '>= 1.9.2'

  s.add_development_dependency "rake", "~> 0"
  s.add_development_dependency "rspec", "~> 3"
  s.add_development_dependency "rubocop", "~> 0.30.0"
end

