$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'bot'

class BotTest < Test::Unit::TestCase
  # Sample data
  A_JID = 'me@example.com'
  # More sample data
  ANOTHER_JID = 'you@example.com'

  def test_register_user
    bot = Bot.new
    bot.cmd_register A_JID, '/'

    assert_equal 1, bot.users.size
    assert_equal ['/'], bot.users[A_JID].paths

    assert_equal 1, bot.paths.size
    assert_equal [A_JID], bot.paths['/'].collect { |u| u.jid }
  end

  def test_register_message
    bot = Bot.new
    msg = bot.cmd_register A_JID, '/proj1'
    assert_equal 'You will get commits for: /proj1', msg

    msg = bot.cmd_register A_JID, '/proj2'
    assert_equal 'You will get commits for: /proj1, /proj2', msg
  end

  def test_register_two_users_same_path
    bot = Bot.new
    bot.cmd_register A_JID, '/proj'
    bot.cmd_register ANOTHER_JID, '/proj'

    assert_equal 2, bot.users.size
    assert_equal ['/proj'], bot.users[A_JID].paths
    assert_equal ['/proj'], bot.users[ANOTHER_JID].paths

    assert_equal 1, bot.paths.size
    assert_equal [A_JID, ANOTHER_JID], jids_for_path(bot, '/proj')
  end

  def test_register_two_paths
    bot = Bot.new
    bot.cmd_register A_JID, '/proj1'
    bot.cmd_register A_JID, '/proj2'

    assert_equal 1, bot.users.size
    assert_equal ['/proj1', '/proj2'], bot.users[A_JID].paths

    assert_equal 2, bot.paths.size
    assert_equal [A_JID], jids_for_path(bot, '/proj1')
    assert_equal [A_JID], jids_for_path(bot, '/proj2')
  end

  def test_unregister
    bot = Bot.new
    bot.cmd_register A_JID, '/proj1'
    bot.cmd_unregister A_JID, '/proj1'

    assert_equal 0, bot.users.size
    assert_equal 0, bot.paths.size
  end

  def test_unregister_message
    bot = Bot.new
    bot.cmd_register A_JID, '/proj1'
    msg = bot.cmd_unregister A_JID, '/proj1'
    assert_equal 'You will no longer get commits for: /proj1', msg
  end

  def test_list
    bot = Bot.new
    bot.cmd_register A_JID, '/proj1'
    bot.cmd_register A_JID, '/proj2'
    msg = bot.cmd_list A_JID
    assert_equal 'You are listening for commits to: /proj1, /proj2', msg
  end

  def test_list_none
    bot = Bot.new
    msg = bot.cmd_list A_JID
    assert_equal 'You are not listening to any commits', msg
  end

  private
  
  def jids_for_path(bot, path)
    bot.paths[path].collect { |u| u.jid }
  end
end
