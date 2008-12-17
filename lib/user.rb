# A user who wishes to receive notifications about commits.
class User
  # The jabber ID of the user.
  attr_accessor :jid
  # A list of paths that the user wishes to be notified about.
  attr_accessor :paths

  # Create a new user +jid+ with no paths to monitor.
  def initialize(jid)
    @jid = jid
    @paths = []
  end

  # Add a path to the list monitored.
  def <<(path)
    @paths << path
    return self
  end

  # Remove a path from the list monitored.
  def delete(path)
    @paths.delete path
  end
end
