require 'forwardable'

module GitHooks
  class Configurations < SimpleDelegator
    include Equalizer.new(:config_file, :git_repository)

    attr_reader :config_file, :git_repository

    def initialize(
      config_file: default_config_file,
      git_repository: default_git_repository
    )
      @config_file = config_file
      @git_repository = git_repository

      super(config_file)
    end

    private

    def default_config_file
      ConfigFile.new('.git_hooks.yml')
    end

    def default_git_repository
      Git.new('.')
    end
  end
end
