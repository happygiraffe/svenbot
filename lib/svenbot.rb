# 

require 'socket'
require 'rubygems'

gem 'xmpp4r-simple'
require 'xmpp4r-simple'

gem 'xmpp4r'
require 'xmpp4r/message'
require 'xmpp4r/xhtml/html'

def html_message(contents)
  msg = Jabber::Message.new
  msg.type = :chat
  html = Jabber::XHTML::HTML.new(contents)
  msg.add(html)
  msg.body = html.to_text
  return msg
end

REPO = ARGV[0]
if !File.directory?(REPO)
  warn "repo #{REPO} does not exist"
  exit 1
end

Jabber::debug = true if ENV['DEBUG']

ARBITRARY_CONSTANT = 256
VIEWCVS_URL = 'http://viewcvs/'

events = []
Thread.new do
  sock_path = "#{REPO}/sock"
  File.delete(sock_path) if File.exist?(sock_path)
  sock = UNIXServer.new sock_path
  loop do
    s1 = sock.accept
    msg = s1.recvfrom(ARBITRARY_CONSTANT)[0]
    puts "** got #{msg.inspect} from sock"
    events << msg
  end
end

users = []
xmpp = Jabber::Simple.new(ARGV[1], ENV['PASSWORD'])
loop do
  puts Time.now
  xmpp.received_messages do |msg|
    case msg.body
    when /^quit\b/
      xmpp.deliver(msg.from, "bye bye")
      xmpp.disconnect
      exit
    when /^register\b/
      users << msg.from
      xmpp.deliver msg.from, "you are now registered to receieve events"
    when /^unregister\b/
      users.delete msg.from
      xmpp.deliver msg.from, "you are no longer registered to receieve events"
    when /^dump\b/
      xmpp.deliver msg.from, users.inspect
    when /^help\b/
      xmpp.deliver msg.from, "commands: quit, register, unregister, dump"
    else
      xmpp.deliver msg.from, "try 'help'…"
    end
  end
  while !events.empty?
    rev = events.shift
    msg = html_message "<a href='#{VIEWCVS_URL}?view=rev&amp;rev=#{rev}'>r#{rev}</a> just committed!"
    users.each do |u|
      xmpp.deliver u, msg
    end
  end
  sleep 1
end
