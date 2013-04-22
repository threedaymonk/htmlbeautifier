require File.expand_path("../lib/htmlbeautifier/version", __FILE__)

spec = Gem::Specification.new do |s|
  s.name              = "htmlbeautifier"
  s.version           = HtmlBeautifier::VERSION::STRING
  s.summary           = "A normaliser/beautifier for HTML that also understands embedded Ruby."
  s.author            = "Paul Battley"
  s.email             = "pbattley@gmail.com"
  s.homepage          = "http://github.com/threedaymonk/htmlbeautifier"

  s.has_rdoc          = true

  s.files             = %w(Rakefile README.md) + Dir.glob("{bin,test,lib}/**/*")
  s.executables       = Dir["bin/**"].map { |f| File.basename(f) }

  s.require_paths     = ["lib"]

  s.add_development_dependency "rake"
end

