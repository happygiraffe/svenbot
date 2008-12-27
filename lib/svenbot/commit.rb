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

    # Populate a new commit object from a repository
    def self.from(repo, id)
      user = `svnlook author '#{repo.dir}' -r '#{id}'`.chomp
      message = `svnlook log '#{repo.dir}' -r '#{id}'`.chomp
      paths = `svnlook changed '#{repo.dir}' -r '#{id}'`.split(/\n/)
      paths.collect! { |p| p.sub(/^..../, '').chomp }
      prefix = pick_prefix(paths)
      prefix = "/" if prefix.empty?
      return Commit.new(id, user, prefix, message)
    end

    private

    # Work out the common prefix of these paths.
    # http://newsgroups.derkeiler.com/Archive/Comp/comp.lang.ruby/2007-08/msg00370.html
    def self.pick_prefix(paths)
      # A list of indexes of differing characters in a & b.
      s = []
      a, b = paths.max.split(//), paths.min.split(//)
      # Note the index of each character that differs.
      a.each_with_index{ |val,i| s << i if val != b[i] }
      # Extract from the first char to the first differing char.
      return (0...s[0]).collect { |j| a[j] }.join
    end
  end
end