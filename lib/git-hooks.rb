require 'equalizer'
require 'yaml'

require 'git'

require_relative 'git_hooks/version'

require_relative 'git_hooks/configurations'
require_relative 'git_hooks/git'
require_relative 'git_hooks/config_file'
require_relative 'git_hooks/installer'
require_relative 'git_hooks/rspec_executor'
require_relative 'git_hooks/rubocop_validator'
require_relative 'git_hooks/trailing_whitespace_validator'

require_relative 'git_hooks/exceptions'
require_relative 'git_hooks/pre_commit'

module GitHooks
  HOOK_SAMPLE_FILE = 'hook.sample'
  HOOKS = [PRE_COMMIT = 'pre-commit']

  class << self
    attr_writer :configurations

    def execute_pre_commits
      configurations.pre_commits.each do |pre_commit|
        puts "Executing #{pre_commit}"
        GitHooks::PreCommit.const_get(pre_commit).validate
      end
    end

    def configurations
      @configurations ||= Configurations.new
    end

    def base_path
      File.expand_path('../..', __FILE__)
    end

    def validate_hooks!
      fail Exceptions::MissingHook, PRE_COMMIT unless valid_pre_commit_hook?
    end

    private

    def valid_pre_commit_hook?
      configurations.pre_commits.empty? ||
        Installer.new(PRE_COMMIT).installed?
    end

    def real_hook_template_path
      File.join(base_path, HOOK_SAMPLE_FILE)
    end
  end
end
