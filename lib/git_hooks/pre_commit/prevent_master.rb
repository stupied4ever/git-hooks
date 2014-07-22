module GitHooks
  module PreCommit
    class PreventMaster
      attr_reader :git_repository

      def self.validate
        new(GitHooks.configurations.git_repository).validate
      end

      def initialize(git_repository)
        @git_repository = git_repository
      end

      def validate
        abort 'Prevented to commit on master' if on_master?
      end

      private

      BRANCH_MASTER = 'master'

      def on_master?
        git_repository.current_branch == BRANCH_MASTER
      end
    end
  end
end
