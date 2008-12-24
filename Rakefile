require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'

spec = Gem::Specification.new do |s|
  s.name = 'svenbot'
  s.version = '0.0.1'
  s.homepage = 'http://github.com/happygiraffe/svenbot/'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README', 'LICENSE']
  s.summary = 'A jabber bot for subversion commits.'
  s.description = s.summary
  s.author = 'Dominic Mitchell'
  s.email = 'dom@happygiraffe.net'
  s.executables = ['svenbot', 'svenbot-notify']
  s.files = %w(LICENSE README Rakefile) + Dir.glob("{bin,lib,spec}/**/*")
  s.require_path = "lib"
  s.bindir = "bin"
  s.add_dependency 'xmpp4r-simple'
  s.add_dependency 'xmpp4r'
  # This stops a warning about it not being specified...
  s.rubyforge_project = ' '
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end

Rake::RDocTask.new do |rdoc|
  files =['README', 'LICENSE', 'lib/**/*.rb']
  rdoc.rdoc_files.add(files)
  rdoc.main = "README" # page to start on
  rdoc.title = "svenbot Docs"
  rdoc.rdoc_dir = 'doc/rdoc' # rdoc output folder
  rdoc.options << '--line-numbers'
end

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*.rb']
end
