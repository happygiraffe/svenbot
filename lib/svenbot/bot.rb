require 'svenbot/message'
require 'svenbot/user_manager'

module Svenbot
  class Bot
    include Message

    def initialize(repo)
      @repo = repo
      @user_manager = UserManager.new
    end

    def cmd_help(jid)
      commands = self.class.public_instance_methods.grep(/^cmd_/).
        collect { |m| m.sub( /^cmd_/, '' ) }.sort.join(', ')
      return html_message("available commands: #{commands}").set_to(jid)
    end

    def cmd_register(jid, path='/')
      @user_manager.register jid, path
      paths = @user_manager.paths_for jid
      msg = "You will get commits for: #{paths.join(', ')}"
      return html_message(msg).set_to(jid)
    end


    # Return a list of paths you are interested in commits for.
    def cmd_list(jid)
      paths = @user_manager.paths_for(jid)
      if paths.empty?
        msg = 'You are not listening to any commits'
      else
        msg = "You are listening for commits to: #{paths.join(', ')}"
      end
      return html_message(msg).set_to(jid)
    end

    # Remove messages about commits to a certain +path+.  If not specified,
    # +path+ defaults to "/".
    def cmd_unregister(jid, path='/')
      @user_manager.unregister jid, path
      msg = "You will no longer get commits for: #{path}"
      return html_message(msg).set_to(jid)
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