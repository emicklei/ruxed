require 'rubygems'
require 'rake/clean'
require 'rake/gempackagetask'
 
spec = Gem::Specification.new do |s|
  s.name = %q{ruxed}
  s.version = "0.1.5"
  s.date = %q{2006-06-07}
  s.summary = %q{XML editor using Ruby for transformation and IE for on-the-fly viewing}
  s.email = %q{ernest.micklei@gmail.com}
  s.homepage = %q{http://www.philemonworks.com/ruxed}
  s.description = %q{Actually this tool was created for editing XDoc files for Apache Maven generated sites}
  s.autorequire = %q{}
  s.has_rdoc = true
  s.authors = ["Ermest Micklei"]
  # bin
  s.files += Dir.new('./bin').entries.select{|e| e =~ /^[^.]/}.collect{|e| 'bin/'+e}
  # lib
  s.files += Dir.new('./lib').entries.select{|e| e =~ /\.rb$/}.collect{|e| 'lib/'+e}
  # samples
  s.files += Dir.new('./samples').entries.select{|e| e =~ /^[^.]/}.collect{|e| 'samples/'+e}
  s.test_files = Dir.new('./tests').entries.select{|e| e =~ /^[^.].*\.rb$/}.collect{|e| 'tests/'+e}
  s.rdoc_options = ["--title", "Ruxed -- XML editor/viewer", "--main", "README", "--line-numbers"]
  s.extra_rdoc_files = ['README']
  s.executables = ["ruxed"]  
  s.default_executable = %q{ruxed}  
  s.add_dependency('ruxtran', '>= 0.1.5')
  s.add_dependency('builder', '>= 1.2.4')
  s.add_dependency('fxruby', '>= 1.4.4')  
end

Rake::GemPackageTask.new(spec) do |pkg| end

task :install do
    Gem::GemRunner.new.run(['install','pkg/ruxed'])
end

desc "Default Task"
task :default => [ :package ,:install ]
   
