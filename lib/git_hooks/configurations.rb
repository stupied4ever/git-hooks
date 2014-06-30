require 'forwardable'

module GitHooks
  class Configurations
    include Equalizer.new(:config_file, :git_repository)
    extend Forwardable

    attr_reader :config_file, :git_repository

    def_delegator :config_file, :pre_commits

    def initialize(
      config_file: ConfigFile.new('.git_hooks.yml'),
      git_repository: Git.new('.')
    )
      @config_file = config_file
      @git_repository = git_repository
    end
  end
end
