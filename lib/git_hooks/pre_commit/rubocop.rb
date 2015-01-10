module GitHooks
  module PreCommit
    class Rubocop
      def self.validate(options = {})
        new(
          GitHooks.configurations.git_repository,
          RubocopValidator.new,
          options
        ).validate
      end

      def initialize(git, rubocop_validator, options = {})
        @git = git
        @rubocop_validator = rubocop_validator
        @options = options
      end

      def validate
        abort 'Check rubocop offences' if offences?
      end

      protected

      attr_reader :git, :rubocop_validator, :options

      private

      def changed_files
        git
          .added_or_modified
          .select(&ruby_files)
      end

      def offences?
        stash_me_maybe { rubocop_validator.errors?(changed_files) }
      end

      def ruby_files
        -> (file) { File.extname(file) == '.rb' }
      end

      def stash_me_maybe
        git.repository.lib.stash_save('rubocop-stash') if options['use_stash']
        yield
      ensure
        git.repository.lib.stash_apply if options['use_stash']
      end
    end
  end
end
