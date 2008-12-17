$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'user'

class UserTest < Test::Unit::TestCase
  def test_initialize
    user = User.new 'user@example.com'
    assert_equal 'user@example.com', user.jid
    assert_equal [], user.paths
  end

  def test_add
    user = User.new 'user@example.com'
    # Should return itself
    assert_equal user, user << '/project'
    # Should have added to paths
    assert_equal ['/project'], user.paths
  end

  def test_delete
    user = User.new 'user@example.com'
    user.paths = %w( /foo /bar )
    user.delete '/bar'
    assert_equal ['/foo'], user.paths
  end
end
