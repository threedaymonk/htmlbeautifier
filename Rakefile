require 'rake'
require 'rake/testtask'

task :default => :test

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/test_*.rb'
  t.verbose = true
end

desc 'Install libraries and command-line utility'
task :install do |t|
  sh 'ruby setup.rb'
end

desc 'Clean up files left over after installation'
task :cleanup do |t|
  rm_f 'InstalledFiles'
  rm_f '.config'
end


require "rubygems"
require "rake/gempackagetask"
require "rake/rdoctask"

task :default => :test

require "rake/testtask"
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

# This builds the actual gem. For details of what all these options
# mean, and other ones you can add, check the documentation here:
#
#   http://rubygems.org/read/chapter/20
#
require "lib/htmlbeautifier/version"
spec = Gem::Specification.new do |s|

  # Change these as appropriate
  s.name              = "htmlbeautifier"
  s.version           = HtmlBeautifier::VERSION::STRING
  s.summary           = "A normaliser/beautifier for HTML that also understands embedded Ruby."
  s.author            = "Paul Battley"
  s.email             = "pbattley@gmail.com"
  s.homepage          = "http://github.com/threedaymonk/htmlbeautifier"

  s.has_rdoc          = true
  s.extra_rdoc_files  = %w(README.txt)
  s.rdoc_options      = %w(--main README.txt)

  # Add any extra files to include in the gem
  s.files             = %w(Rakefile README.txt) + Dir.glob("{bin,test,lib}/**/*")
  s.executables       = FileList["bin/**"].map { |f| File.basename(f) }

  s.require_paths     = ["lib"]

  # If you want to depend on other gems, add them here, along with any
  # relevant versions
  # s.add_dependency("some_other_gem", "~> 0.1.0")

  # If your tests use any gems, include them here
  # s.add_development_dependency("mocha")
end

# This task actually builds the gem. We also regenerate a static
# .gemspec file, which is useful if something (i.e. GitHub) will
# be automatically building a gem for this project. If you're not
# using GitHub, edit as appropriate.
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec

  # Generate the gemspec file for github.
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, "w") {|f| f << spec.to_ruby }
end

# Generate documentation
Rake::RDocTask.new do |rd|
  rd.main = "README.txt"
  rd.rdoc_files.include("README.txt", "lib/**/*.rb")
  rd.rdoc_dir = "rdoc"
end

desc 'Clear out RDoc and generated packages'
task :clean => [:clobber_rdoc, :clobber_package] do
  rm "#{spec.name}.gemspec"
end
