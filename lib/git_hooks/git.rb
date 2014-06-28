require 'forwardable'

module GitHooks
  class Git
    extend Forwardable

    attr_reader :working_folder

    def_delegator :repository, :current_branch

    def initialize(working_folder)
      @working_folder = working_folder
    end

    def repository
      ::Git.open(working_folder)
    end

    def added_or_modified
      added = repository.status.added
      modified = repository.status.changed

      added.merge(modified).keys
    end

    def clean?
      (added_files + modified_files + deleted_files + untracked_files).empty?
    end

    private

    def added_files
      repository.status.added.keys
    end

    def modified_files
      repository.status.changed.keys
    end

    def deleted_files
      repository.status.deleted.keys
    end

    def untracked_files
      repository.status.untracked.keys
    end
  end
end
