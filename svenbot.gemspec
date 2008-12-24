Gem::Specification.new do |s|
  s.name = 'svenbot'
  s.version = '0.0.1'
  s.homepage = 'http://github.com/happygiraffe/svenbot/'
  s.has_rdoc = true
  s.extra_rdoc_files = ['LICENSE']
  s.summary = 'A jabber bot for subversion commits.'
  s.description = s.summary
  s.author = 'Dominic Mitchell'
  s.email = 'dom@happygiraffe.net'
  s.executables = ['svenbot', 'svenbot-notify']
  # Can't use Dir.glob on github.
  s.files = %w(
    LICENSE
    README.textile
    Rakefile
    bin/svenbot
    bin/svenbot-notify
    lib/svenbot/bot.rb
    lib/svenbot/commit.rb
    lib/svenbot/message.rb
    lib/svenbot/repo.rb
    lib/svenbot/user.rb
    lib/svenbot/user_manager.rb
    svenbot.gemspec
  )
  s.test_files = %w(
    test/svenbot/bot_test.rb
    test/svenbot/commit_test.rb
    test/svenbot/message_test.rb
    test/svenbot/repo_test.rb
    test/svenbot/user_manager_test.rb
    test/svenbot/user_test.rb
  )
  s.require_path = "lib"
  s.bindir = "bin"
  s.add_dependency 'xmpp4r-simple'
  s.add_dependency 'xmpp4r'
  # This stops a warning about it not being specified...
  s.rubyforge_project = ' '
end
