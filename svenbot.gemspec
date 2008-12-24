# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{svenbot}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dominic Mitchell"]
  s.date = %q{2008-12-24}
  s.description = %q{A jabber bot for subversion commits.}
  s.email = %q{dom@happygiraffe.net}
  s.executables = ["svenbot", "svenbot-notify"]
  s.extra_rdoc_files = ["bin/svenbot", "bin/svenbot-notify", "lib/svenbot/bot.rb", "lib/svenbot/commit.rb", "lib/svenbot/message.rb", "lib/svenbot/repo.rb", "lib/svenbot/user.rb", "lib/svenbot/user_manager.rb", "LICENSE", "README.textile"]
  s.files = ["bin/svenbot", "bin/svenbot-notify", "lib/svenbot/bot.rb", "lib/svenbot/commit.rb", "lib/svenbot/message.rb", "lib/svenbot/repo.rb", "lib/svenbot/user.rb", "lib/svenbot/user_manager.rb", "LICENSE", "Rakefile", "README.textile", "svenbot.gemspec", "test/svenbot/bot_test.rb", "test/svenbot/commit_test.rb", "test/svenbot/message_test.rb", "test/svenbot/repo_test.rb", "test/svenbot/user_manager_test.rb", "test/svenbot/user_test.rb", "Manifest"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/happygiraffe/svenbot}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Svenbot", "--main", "README.textile"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{svenbot}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A jabber bot for subversion commits.}
  s.test_files = ["test/svenbot/bot_test.rb", "test/svenbot/commit_test.rb", "test/svenbot/message_test.rb", "test/svenbot/repo_test.rb", "test/svenbot/user_manager_test.rb", "test/svenbot/user_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<echoe>, [">= 0"])
    else
      s.add_dependency(%q<echoe>, [">= 0"])
    end
  else
    s.add_dependency(%q<echoe>, [">= 0"])
  end
end
