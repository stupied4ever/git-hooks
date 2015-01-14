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
        abort(
          "Prevented commit with debugger in #{files_with_debugger}"
        ) if files_with_debugger.any?
      end

      private

      def files_with_debugger
        git_repository
          .added_or_modified
          .select(&ruby_files)
          .select(&contains_debugger?)
      end

      def ruby_files
        -> (file) { File.extname(file) == '.rb' }
      end

      def contains_debugger?
        -> (file) { File.read(file) =~ debugger_regex }
      end

      def debugger_regex
        Regexp.union(
          %w(binding.pry binding.remote_pry save_and_open_page debugger)
        )
      end
    end
  end
end
