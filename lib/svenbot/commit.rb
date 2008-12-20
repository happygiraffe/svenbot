module Svenbot
  # Representation of a commit message
  class Commit
    # Identifier for this commit
    attr_reader :id
    # Who made this commit?
    attr_reader :user
    # What part of the repository did this affect?
    attr_reader :path_prefix
    # Why was this commit made?
    attr_reader :message

    # Create a new commit.
    def initialize(id, user, path_prefix, message)
      @id = id
      @user = user
      @path_prefix = path_prefix
      @message = message
    end
  end
end