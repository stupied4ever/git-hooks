module GitHooks
  module PreCommit
    class TrailingWhitespace
      attr_reader :git_repository, :trailing_whitespace_validator

      def self.validate
        new(
          GitHooks.configurations.git_repository,
          TrailingWhitespaceValidator.new
        ).validate
      end

      def initialize(git_repository, trailing_whitespace_validator)
        @git_repository = git_repository
        @trailing_whitespace_validator = trailing_whitespace_validator
      end

      def validate
        abort(
          "Prevented commit with trailing whitespace in files #{offenses}"
        ) if offenses.any?
      end

      def changed_files
        git_repository
          .added_or_modified
          .select { |file| File.extname(file) == '.rb' }
      end

      def offenses
        changed_files.map do |file|
          trailing_whitespace_validator.errors?([file])
        end
      end
    end
  end
end
