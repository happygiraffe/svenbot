$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'user'

class UserTest < Test::Unit::TestCase
  attr_reader :user

  def setup
    @user = User.new 'user@example.com'
  end

  def test_initialize
    assert_equal 'user@example.com', user.jid
    assert_equal [], user.paths
  end

  def test_add
    # Should return itself
    assert_equal user, user << '/project'
    # Should have added to paths
    assert_equal ['/project'], user.paths
  end

  def test_delete
    user.paths = %w( /foo /bar )
    user.delete '/bar'
    assert_equal ['/foo'], user.paths
  end
end
