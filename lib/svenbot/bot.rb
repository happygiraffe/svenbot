require 'svenbot/user_manager'

module Svenbot
  class Bot
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

  end

end