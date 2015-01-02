module GitHooks
  module PreCommit
    class Rspec
      def self.validate
        new(
          GitHooks.configurations.git_repository,
          RspecExecutor.new
        ).validate
      end

      def initialize(git_repository, rspec_executor)
        @git_repository = git_repository
        @rspec_executor = rspec_executor
      end

      def validate
        return if git_repository.clean?

        abort 'Prevented broken commit' if rspec_executor.errors?
      end

      protected

      attr_reader :git_repository, :rspec_executor
    end
  end
end
