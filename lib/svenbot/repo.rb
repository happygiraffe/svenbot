module Svenbot
  # A subversion repository on the filesystem.
  class Repo
    # The directory the repository lives in.
    attr_reader :dir

    # Create a new Repo.
    def initialize(dir)
      @dir = dir
    end

    # Return a directory within the repository for use by svenbot. Defaults
    # to a subdirectory "svenbot".
    def meta_dir
      return "#{dir}/svenbot"
    end

    # Create the meta directory if needed.
    def make_meta_dir
      Dir.mkdir(meta_dir) unless File.directory?(meta_dir)
    end
  end
end
