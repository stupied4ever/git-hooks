# -*- encoding : utf-8 -*-
require 'forwardable'

module GitHooks
  class Configurations < SimpleDelegator
    include Equalizer.new(:config_file, :git_repository)

    attr_reader :config_file, :git_repository

    def initialize(options = {})
      options[:config_file] ||=  default_config_file
      options[:git_repository] ||= default_git_repository

      @config_file = options[:config_file]
      @git_repository = options[:git_repository]

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
