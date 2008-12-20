$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'svenbot/message'

module Svenbot
  class MessageTest < Test::Unit::TestCase
    include Message

    def test_html_message
      msg = html_message("hello <em>world</em>")
      assert_equal :chat, msg.type
      assert_equal "hello world", msg.body
      assert_equal "<html xmlns='http://jabber.org/protocol/xhtml-im'><body " +
        "xmlns='http://www.w3.org/1999/xhtml'>hello <em>world</em></body></html>",
        msg.first_element('html').to_s
    end
  end
end