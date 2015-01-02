module GitHooks
  module PreCommit
    class Rubocop
      def self.validate
        new(
          GitHooks.configurations.git_repository, RubocopValidator.new
        ).validate
      end

      def initialize(git, rubocop_validator, options = {})
        @git, @rubocop_validator = git, rubocop_validator
        @options = options
      end

      def validate
        abort 'Check rubocop offences' if offences?
      end

      attr_reader :git, :rubocop_validator, :options

      private

      def changed_files
        git
          .added_or_modified
          .select { |file| File.extname(file) == '.rb' }
      end

      def offences?
        stash_me_maybe { rubocop_validator.errors?(changed_files) }
      end

      def stash_me_maybe
        git.repository.lib.stash_save('rubocop-stash') if options[:use_stash]
        yield
      ensure
        git.repository.lib.stash_apply if options[:use_stash]
      end
    end
  end
end
