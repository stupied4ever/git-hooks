module GitHooks
  class RubocopValidator
    def errors?(files)
      return false if files.empty?

      system("rubocop #{files.join(' ')} --force-exclusion") == false
    end
  end
end
