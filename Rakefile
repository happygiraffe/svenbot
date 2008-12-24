require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/rdoctask'

gem 'echoe'
require 'echoe'

Echoe.new("svenbot", "0.0.1") do |p|
  p.author = 'Dominic Mitchell'
  p.email = 'dom@happygiraffe.net'
  p.url = 'http://github.com/happygiraffe/svenbot'
  p.description = 'A jabber bot for subversion commits.'
  p.need_zip = true
  p.ignore_pattern = /^(pkg|doc|nbproject)|\.git/
  p.retain_gemspec = true
end
