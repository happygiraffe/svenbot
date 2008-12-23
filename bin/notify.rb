#!/usr/bin/ruby
#
# Send a message to the bot.

require 'socket'
require 'svenbot/repo'

repo = Svenbot::Repo.new(ARGV[0])
rev = ARGV[1]

sock = UNIXSocket.open "#{repo.meta_dir}/sock"
sock.send rev, 0
sock.close
