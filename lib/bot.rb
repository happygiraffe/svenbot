require 'message'

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
  def register(jid, path='/')
    user = get_user(jid)
    user << path
    add_path_for_user path, user
    return "You will get commits for: #{user.paths.join(', ')}"
  end

  def unregister(jid, path='/')
    user = @users.delete jid
    if user && @paths[path]
      @paths[path].delete user
      @paths.delete path if @paths[path].empty?
    end
    return "You will no longer get commits for: #{path}"
  end

  private

  def get_user(jid)
    @users[jid] ||= User.new(jid)
  end

  # Fill in the reverse mapping so we know which paths are of interest to
  # which users.
  def add_path_for_user(path, user)
    @paths[path] ||= []
    @paths[path] << user
  end
end
