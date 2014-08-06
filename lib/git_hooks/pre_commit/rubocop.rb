# -*- encoding : utf-8 -*-
module GitHooks
  module PreCommit
    class Rubocop
      attr_reader :git_repository, :rubocop_validator

      def self.validate
        new(
          GitHooks.configurations.git_repository, RubocopValidator.new
        ).validate
      end

      def initialize(git_repository, rubocop_validator)
        @git_repository, @rubocop_validator = git_repository, rubocop_validator
      end

      def validate
        abort 'Check rubocop offences' if offences?
      end

      private

      def changed_files
        git_repository
          .added_or_modified
          .select { |file| File.extname(file) == '.rb' }
      end

      def offences?
        rubocop_validator.errors?(changed_files)
      end
    end
  end
end
