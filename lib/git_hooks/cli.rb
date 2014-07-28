require 'thor'

require_relative '../git-hooks'

module GitHooks
  class CLI < Thor
    desc 'install HOOK', 'Install some hook'
    long_desc <<-LONGDESC
      Install some hook:

      $ git_hooks install pre-commit
    LONGDESC
    def install(hook)
      GitHooks.install_hook(hook)
    end

    desc 'Create configuration file', 'Create a configuration file'
    long_desc <<-LONGDESC
      Create a configuration file base on git_hooks.yml.examle

      $ git_hooks configure
    LONGDESC
    def configure
      example_file = File.expand_path(
        '../../../git_hooks.yml.example', __FILE__
      )
      destination_path = File.expand_path('.git_hooks.yml', Dir.pwd)
      FileUtils.cp(example_file, destination_path)
    end
  end
end
