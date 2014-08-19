module GitHooks
  module PreCommit
    class Whitespace
      attr_reader :git_repository, :whitespace_validator

      def self.validate
        new(GitHooks.git_repository, WhitespaceValidator.new).validate
      end

      def initialize(git_repository, whitespace_validator)
        @git_repository = git_repository
        @whitespace_validator = whitespace_validator
      end

      def validate
        abort 'Check presence of trailling whitespace' if offences?
      end

      private

      def changed_files
        git_repository
          .added_or_modified
          .select { |file| File.extname(file) == '.rb' }
      end

      def offences?
        whitespace_validator.errors?(changed_files)
      end
    end
  end
end
