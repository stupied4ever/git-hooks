require 'thor'

require_relative '../git-hooks'

module GitHooks
  class CLI < Thor
    desc 'install HOOK', 'Install some hook'
    long_desc <<-LONGDESC
      Install some hook:

      > $ git_hooks install pre-commit
    LONGDESC
    def install(hook)
      GitHooks.install_hook(hook)
    end
  end
end
