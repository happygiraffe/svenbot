$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'commit'

class CommitTest < Test::Unit::TestCase

  def test_commit_fields
    commit = Commit.new '12345', 'dom', 'I made this!'
    assert_equal 'dom', commit.user
    assert_equal '12345', commit.id
    assert_equal 'I made this!', commit.message
  end
end
