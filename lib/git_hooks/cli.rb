require 'thor'
require 'logger'

require_relative '../git-hooks'

module GitHooks
  class CLI < Thor
    desc 'install HOOK', 'Install some hook'
    option :force, type: :boolean
    option :ruby_path, type: :string
    long_desc <<-LONGDESC
      Install some hook:

      $ git_hooks install pre-commit

      Intall all hooks:

      $ git_hooks install
    LONGDESC
    def install(*hooks)
      hooks = GitHooks::HOOKS if hooks.empty?
      installer = GitHooks::Installer.new(
        *hooks,
        ruby_path: options[:ruby_path],
        logger: logger
      )
      installer.install(options[:force])
    end

    desc 'Init GitHooks on current folder', 'Create a configuration file'
    long_desc <<-LONGDESC
      Create a configuration file based on git_hooks.yml.example

      $ git_hooks init
    LONGDESC
    def init
      example_file = File.expand_path(
        '../../../git_hooks.yml.example', __FILE__
      )
      destination_path = File.expand_path('.git_hooks.yml', Dir.pwd)
      logger.info "Writing to file #{destination_path}"
      FileUtils.cp(example_file, destination_path)
    end

    map %w(--version -v) => :version

    desc 'version', 'Show git-hooks version'
    def version
      puts GitHooks::VERSION
    end

    private

    def logger
      @logger ||= Logger.new($stdout)
    end
  end
end
