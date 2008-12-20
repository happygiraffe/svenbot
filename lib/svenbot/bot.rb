require 'svenbot/message'
require 'svenbot/user_manager'

module Svenbot
  class Bot
    include Message

    def initialize
      @user_manager = UserManager.new
    end

    def cmd_register(jid, path='/')
      @user_manager.register jid, path
      paths = @user_manager.paths_for jid
      return "You will get commits for: #{paths.join(', ')}"
    end


    # Return a list of paths you are interested in commits for.
    def cmd_list(jid)
      paths = @user_manager.paths_for(jid)
      if paths.empty?
        return 'You are not listening to any commits'
      else
        return "You are listening for commits to: #{paths.join(', ')}"
      end
    end

    # Remove messages about commits to a certain +path+.  If not specified,
    # +path+ defaults to "/".
    def cmd_unregister(jid, path='/')
      @user_manager.unregister jid, path
      return "You will no longer get commits for: #{path}"
    end

    # Return a list of messages to send out for +commit+.
    def commit_messages(commit)
      msg = "#{commit.user} committed #{commit.id}: #{commit.message}"
      @user_manager.users_for(commit.path_prefix).collect do |jid|
        html_message(msg).set_to(jid)
      end
    end

  end

end