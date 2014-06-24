module GitHooks
  module PreCommit
    class Rubocop
      def validate
        abort 'Check rubocop offences' unless run_rubocop
      end

      private

      ADDED_OR_MODIFIED = /A|AM|^M/.freeze

      def changed_ruby_files
        `git status --porcelain`.split(/\n/)
          .select { |file| file =~ ADDED_OR_MODIFIED }
          .map    { |file| file.split(' ')[1]        }
          .select { |file| File.extname(file) == '.rb' }
      end

      def run_rubocop
        files = changed_ruby_files
        system("rubocop #{files.join(' ')} --force-exclusion") if files.any?
      end
    end
  end
end
