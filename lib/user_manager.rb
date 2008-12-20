require 'message'
require 'set'
require 'user'

# Keep state tracking who is interested in what commits.  Users can register
# or unregister for paths.  Commits to those paths will result in a message
# being emitted.
class UserManager
  # A hash of registered users.
  attr_reader :users
  # A hash of paths we are interested in, and which users map to them.
  attr_reader :paths

  include Message

  # Create a new UserManager instance
  def initialize
    @users = {}
    @paths = {}
  end

  # Register +jid+ as interested in commits to +path+.  If path isn't
  # specified, default to "everything" (i.e. "/")
  def register(jid, path)
    user = get_user(jid)
    user << path
    add_path_for_user path, user
  end

  # Remove messages about commits to a certain +path+.
  def unregister(jid, path)
    user = @users.delete jid
    remove_path_for_user path, user if user
  end

  # Return a list of messages to send out for +commit+.
  def commit_messages(commit)
    msg = "#{commit.user} committed #{commit.id}: #{commit.message}"
    users_interested_in_path(commit.path_prefix).collect do |u|
      html_message(msg).set_to(u.jid)
    end
  end

  # Return a sorted list of paths that +jid+ has registered.
  def paths_for(jid)
    get_user(jid).paths.sort
  end

  private

  # Return an existing user or create a new one.
  def get_user(jid)
    @users[jid] ||= User.new(jid)
  end

  # Fill in the reverse mapping so we know which paths are of interest to
  # which users.
  def add_path_for_user(path, user)
    @paths[path] ||= Set.new
    @paths[path] << user
  end

  # Remove user from a given path.  If there are no further users listening
  # for a given path, remove the whole path.
  def remove_path_for_user(path, user)
    if @paths[path]
      @paths[path].delete user
      @paths.delete path if @paths[path].empty?
    end
  end

  # Return a list of users for a given path.
  def users_for_path(path)
    @paths[path] || Set.new
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
