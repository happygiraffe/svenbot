require 'cgi'
require 'svenbot/message'
require 'svenbot/user_manager'

module Svenbot
  class Bot
    attr_accessor :viewvc_url
    include Message

    def initialize(repo)
      @repo = repo
      @user_manager = UserManager.new
    end

    def dispatch_cmd(msg)
      cmd, args = msg.body.split(' ', 2)
      method = "cmd_#{cmd}".to_sym
      if self.class.method_defined? method
        return self.send(method, msg.from, args)
      else
        return html_message("unknown command '#{cmd}'").set_to(msg.from)
      end
    end

    def cmd_help(jid, unused)
      commands = self.class.public_instance_methods.grep(/^cmd_/).
        collect { |m| m.sub( /^cmd_/, '' ) }.sort.join(', ')
      return html_message("available commands: #{commands}").set_to(jid)
    end

    def cmd_register(jid, path)
      path = "/" if path.empty?
      @user_manager.register jid, path
      paths = @user_manager.paths_for jid
      msg = "You will get commits for: #{paths.join(', ')}"
      return html_message(msg).set_to(jid)
    end


    # Return a list of paths you are interested in commits for.
    def cmd_list(jid, unused)
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
    def cmd_unregister(jid, path)
      path = "/" if path.empty?
      @user_manager.unregister jid, path
      msg = "You will no longer get commits for: #{path}"
      return html_message(msg).set_to(jid)
    end

    # Return a list of messages to send out for +commit+.
    def commit_messages(commit)
      msg = format_commit_message commit
      @user_manager.users_for(commit.path_prefix).collect do |jid|
        html_message(msg).set_to(jid)
      end
    end

    private

    def format_commit_message(c)
      msg = CGI.escapeHTML(c.message)
      user = CGI.escapeHTML(c.user)
      cid = c.id
      if viewvc_url
        cid = "<a href='#{viewvc_url}?view=rev&rev=#{cid}'>#{cid}</a>"
      end
      "<b>#{user}</b> committed #{cid}:<br/>#{msg}"
    end
  end

end