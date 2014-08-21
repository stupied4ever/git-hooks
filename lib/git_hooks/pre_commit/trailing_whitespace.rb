module GitHooks
  module PreCommit
    class TrailingWhitespace
      attr_reader :git_repository, :trailing_whitespace_validator

      def self.validate
        new(GitHooks.git_repository, TrailingWhitespaceValidator.new).validate
      end

      def initialize(git_repository, trailing_whitespace_validator)
        @git_repository = git_repository
        @trailing_whitespace_validator = trailing_whitespace_validator
      end

      def validate
        abort 'Check presence of trailling space' if offences?
      end

      private

      def changed_files
        git_repository
          .added_or_modified
          .select { |file| File.extname(file) == '.rb' }
      end

      def offences?
        trailing_whitespace_validator.errors?(changed_files)
      end
    end
  end
end
