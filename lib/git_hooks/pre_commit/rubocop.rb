module GitHooks
  module PreCommit
    class Rubocop
      RUBOCOP_STASH_NAME = 'rubocop-stash'

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

      def stash_me_maybe(&blk)
        return yield unless stash_around?

        stash_around(&blk)
      end

      def stash_around
        git.repository.lib.stash_save(RUBOCOP_STASH_NAME)
        yield
      ensure
        git.repository.lib.stash_pop(rubocop_stash_id) if rubocop_stash?
      end

      def stash_around?
        options['use_stash']
      end

      def rubocop_stash?
        rubocop_stash_id
      end

      def rubocop_stash_id
        Array(
          git.repository.lib
            .stashes_all
            .rassoc(RUBOCOP_STASH_NAME)
        ).first
      end
    end
  end
end
