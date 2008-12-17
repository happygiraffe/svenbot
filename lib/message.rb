require 'rubygems'

gem 'xmpp4r'
require 'xmpp4r/message'
require 'xmpp4r/xhtml/html'

# A factory for messages.
module Message
  # Create a Jabber::Message with both HTML and text body.  Pass in a
  # string of HTML.
  def html_message(contents)
    msg = Jabber::Message.new
    msg.type = :chat
    html = Jabber::XHTML::HTML.new(contents)
    msg.add(html)
    msg.body = html.to_text
    return msg
  end
end
