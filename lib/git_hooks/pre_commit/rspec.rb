module GitHooks
  module PreCommit
    class Rspec
      def validate
        return if system('bundle exec rspec --format=progress')

        abort 'Prevented broken commit'
      end
    end
  end
end
