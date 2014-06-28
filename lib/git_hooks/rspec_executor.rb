module GitHooks
  class RspecExecutor
    def errors?
      !system(rspec_command)
    end

    private

    def rspec_command
      'bundle exec rspec --format=progress'
    end
  end
end
