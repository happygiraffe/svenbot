require 'message'
require 'set'

# Keep state tracking who is interested in what commits.  Users can register
# or unregister for paths.  Commits to those paths will result in a message
# being emitted.
class Bot
  # A hash of registered users.
  attr_reader :users
  # A hash of paths we are interested in, and which users map to them.
  attr_reader :paths

  include Message

  # Create a new Bot instance
  def initialize
    @users = {}
    @paths = {}
  end

  # Register +jid+ as interested in commits to +path+.  If path isn't
  # specified, default to "everything" (i.e. "/")
  def cmd_register(jid, path='/')
    user = get_user(jid)
    user << path
    add_path_for_user path, user
    return "You will get commits for: #{user.paths.join(', ')}"
  end

  # Remove messages about commits to a certain +path+.  If not specified,
  # +path+ defaults to "/".
  def cmd_unregister(jid, path='/')
    user = @users.delete jid
    if user && @paths[path]
      @paths[path].delete user
      @paths.delete path if @paths[path].empty?
    end
    return "You will no longer get commits for: #{path}"
  end

  # Return a list of paths you are interested in commits for.
  def cmd_list(jid)
    user = @users[jid]
    return 'You are not listening to any commits' unless user
    return "You are listening for commits to: #{user.paths.join(', ')}"
  end

  # Return a list of messages to send out for +commit+.
  def commit_messages(commit)
    msg = "#{commit.user} committed #{commit.id}: #{commit.message}"
    users_interested_in_path(commit.path_prefix).collect do |u|
      html_message(msg).set_to(u.jid)
    end
  end

  private

  # Return an existing user or create a new one.
  def get_user(jid)
    @users[jid] ||= User.new(jid)
  end

  # Fill in the reverse mapping so we know which paths are of interest to
  # which users.
  def add_path_for_user(path, user)
    @paths[path] ||= []
    @paths[path] << user
  end

  # Return a list of users for a given path.
  def users_for_path(path)
    @paths[path] || []
  end

  # Return a list of all users who are interested in a particular path.
  def users_interested_in_path(path)
    interested = Set.new
    while path != "/"
      interested.merge users_for_path(path)
      path = File.dirname path
    end
    # Be nice to get rid of this special case.
    interested.merge users_for_path(path)
    return interested
  end
end
