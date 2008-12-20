$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'commit'
require 'bot'

class BotTest < Test::Unit::TestCase
  attr_reader :bot
  # Sample data
  A_JID = 'me@example.com'
  # More sample data
  ANOTHER_JID = 'you@example.com'

  def setup
    @bot = Bot.new
  end

  def test_register_user
    bot.cmd_register A_JID, '/'

    assert_equal 1, bot.users.size
    assert_equal ['/'], bot.users[A_JID].paths

    assert_equal 1, bot.paths.size
    assert_equal [A_JID], bot.paths['/'].collect { |u| u.jid }
  end

  def test_register_message
    msg = bot.cmd_register A_JID, '/proj1'
    assert_equal 'You will get commits for: /proj1', msg

    msg = bot.cmd_register A_JID, '/proj2'
    assert_equal 'You will get commits for: /proj1, /proj2', msg
  end

  def test_register_two_users_same_path
    bot.cmd_register A_JID, '/proj'
    bot.cmd_register ANOTHER_JID, '/proj'

    assert_equal 2, bot.users.size
    assert_equal ['/proj'], bot.users[A_JID].paths
    assert_equal ['/proj'], bot.users[ANOTHER_JID].paths

    assert_equal 1, bot.paths.size
    assert_equal [A_JID, ANOTHER_JID], jids_for_path(bot, '/proj').sort
  end

  def test_register_two_paths
    bot.cmd_register A_JID, '/proj1'
    bot.cmd_register A_JID, '/proj2'

    assert_equal 1, bot.users.size
    assert_equal ['/proj1', '/proj2'], bot.users[A_JID].paths

    assert_equal 2, bot.paths.size
    assert_equal [A_JID], jids_for_path(bot, '/proj1')
    assert_equal [A_JID], jids_for_path(bot, '/proj2')
  end

  def test_unregister
    bot.cmd_register A_JID, '/proj1'
    bot.cmd_unregister A_JID, '/proj1'

    assert_equal 0, bot.users.size
    assert_equal 0, bot.paths.size
  end

  def test_unregister_message
    bot.cmd_register A_JID, '/proj1'
    msg = bot.cmd_unregister A_JID, '/proj1'
    assert_equal 'You will no longer get commits for: /proj1', msg
  end

  def test_list
    bot.cmd_register A_JID, '/proj1'
    bot.cmd_register A_JID, '/proj2'
    msg = bot.cmd_list A_JID
    assert_equal 'You are listening for commits to: /proj1, /proj2', msg
  end

  def test_list_none
    msg = bot.cmd_list A_JID
    assert_equal 'You are not listening to any commits', msg
  end

  def test_commit_messages
    bot.cmd_register(A_JID, '/proj1')
    c = Commit.new('12345', 'arthur', '/proj1', 'fix bug 42')
    msgs = bot.commit_messages c
    assert_equal 1, msgs.size
    assert_equal A_JID, msgs[0].to.to_s
    assert_equal 'arthur committed 12345: fix bug 42', msgs[0].body
  end

  def test_commit_messages_understand_prefix
    bot.cmd_register(A_JID, '/')
    c = Commit.new('12345', 'arthur', '/proj1/README', 'fix bug 42')
    msgs = bot.commit_messages c
    assert_equal 1, msgs.size
    assert_equal A_JID, msgs[0].to.to_s
  end

  private
  
  def jids_for_path(bot, path)
    bot.paths[path].collect { |u| u.jid }
  end
end
