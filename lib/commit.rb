# Representation of a commit message
class Commit
  # Identifier for this commit
  attr_reader :id
  # Who made this commit?
  attr_reader :user
  # Why was this commit made?
  attr_reader :message

  # Create a new commit.
  def initialize(id, user, message)
    @id = id
    @user = user
    @message = message
  end
end
