# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'svenbot/repo'

module Svenbot
  class RepoTest < Test::Unit::TestCase
    def test_dir
      assert_equal('/tmp/repo', Repo.new('/tmp/repo').dir)
    end
    def test_meta_dir
      assert_equal('/tmp/repo/svenbot', Repo.new('/tmp/repo').meta_dir)
    end
  end
end
