require 'rake'
require 'rake/testtask'

task :default => :test

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/*_test.rb'
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
