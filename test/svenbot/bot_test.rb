# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'svenbot/bot'
require 'svenbot/repo'
require 'tmpdir'

module Svenbot
  class BotTest < Test::Unit::TestCase
    attr_reader :bot
    # Sample data
    A_JID = 'me@example.com'
    # More sample data
    ANOTHER_JID = 'you@example.com'

    def setup
      @bot = Bot.new(Repo.new("#{Dir.tmpdir}/repo"))
    end

    def test_register_message
      msg = bot.cmd_register A_JID, '/proj1'
      assert_equal 'You will get commits for: /proj1', msg
    end

    def test_register_message_for_two_projects
      msg = bot.cmd_register A_JID, '/proj1'
      msg = bot.cmd_register A_JID, '/proj2'
      assert_equal 'You will get commits for: /proj1, /proj2', msg
    end

    def test_unregister_message
      msg = bot.cmd_register A_JID, '/proj1'
      msg = bot.cmd_unregister A_JID, '/proj1'
      assert_equal 'You will no longer get commits for: /proj1', msg
    end

    def test_list
      msg = bot.cmd_register A_JID, '/proj1'
      msg = bot.cmd_register A_JID, '/proj2'
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

  end
end