module GitHooks
  module PreCommit
    class PreventDebugger
      attr_reader :git_repository

      def self.validate
        new(GitHooks.configurations.git_repository).validate
      end

      def initialize(git_repository)
        @git_repository = git_repository
      end

      def validate
        abort 'Prevented to commit with debugger' if any_debugger?
      end

      private

      def any_debugger?
        git_repository.added_or_modified.any? do |file_name|
          File.read(file_name) =~ debugger_regex
        end
      end

      def debugger_regex
        Regexp.union(
          %w(
            binding.pry binding.remote_pry
            save_and_open_page debugger logger.debug
          )
        )
      end
    end
  end
end
