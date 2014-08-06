# -*- encoding : utf-8 -*-
module GitHooks
  module PreCommit
    class Rspec
      attr_reader :git_repository, :rspec_executor

      def self.validate
        new(
          GitHooks.configurations.git_repository, RspecExecutor.new
        ).validate
      end

      def initialize(git_repository, rspec_executor)
        @git_repository, @rspec_executor = git_repository, rspec_executor
      end

      def validate
        return if git_repository.clean?

        abort 'Prevented broken commit' if rspec_executor.errors?
      end
    end
  end
end
