# Send a message to the bot.

require 'socket'

repo, rev = ARGV

sock = UNIXSocket.open "#{repo}/sock"
sock.send rev, 0
sock.close
