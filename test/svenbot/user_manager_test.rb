$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'svenbot/commit'
require 'svenbot/user_manager'

module Svenbot
  class UserManagerTest < Test::Unit::TestCase
    attr_reader :um
    # Sample data
    A_JID = 'me@example.com'
    # More sample data
    ANOTHER_JID = 'you@example.com'

    def setup
      @um = UserManager.new
    end

    def test_register_user
      um.register A_JID, '/'

      assert_equal 1, um.users.size
      assert_equal ['/'], um.users[A_JID].paths

      assert_equal 1, um.paths.size
      assert_equal [A_JID], um.paths['/'].collect { |u| u.jid }
    end

    def test_register_two_users_same_path
      um.register A_JID, '/proj'
      um.register ANOTHER_JID, '/proj'

      assert_equal 2, um.users.size
      assert_equal ['/proj'], um.users[A_JID].paths
      assert_equal ['/proj'], um.users[ANOTHER_JID].paths

      assert_equal 1, um.paths.size
      assert_equal [A_JID, ANOTHER_JID], jids_for_path(um, '/proj').sort
    end

    def test_register_two_paths
      um.register A_JID, '/proj1'
      um.register A_JID, '/proj2'

      assert_equal 1, um.users.size
      assert_equal ['/proj1', '/proj2'], um.users[A_JID].paths

      assert_equal 2, um.paths.size
      assert_equal [A_JID], jids_for_path(um, '/proj1')
      assert_equal [A_JID], jids_for_path(um, '/proj2')
    end

    def test_unregister
      um.register A_JID, '/proj1'
      um.unregister A_JID, '/proj1'

      assert_equal 0, um.users.size
      assert_equal 0, um.paths.size
    end

    def test_commit_messages
      um.register(A_JID, '/proj1')
      c = Commit.new('12345', 'arthur', '/proj1', 'fix bug 42')
      msgs = um.commit_messages c
      assert_equal 1, msgs.size
      assert_equal A_JID, msgs[0].to.to_s
      assert_equal 'arthur committed 12345: fix bug 42', msgs[0].body
    end

    def test_commit_messages_understand_prefix
      um.register(A_JID, '/')
      c = Commit.new('12345', 'arthur', '/proj1/README', 'fix bug 42')
      msgs = um.commit_messages c
      assert_equal 1, msgs.size
      assert_equal A_JID, msgs[0].to.to_s
    end

    def test_paths_for
      um.register A_JID, '/proj1'
      um.register A_JID, '/proj2'
      assert_equal %w[ /proj1 /proj2 ], um.paths_for(A_JID).sort
    end

    private
  
    def jids_for_path(bot, path)
      bot.paths[path].collect { |u| u.jid }
    end
  end
end