require 'equalizer'
require 'yaml'

require 'git'

require_relative 'git_hooks/configurations'
require_relative 'git_hooks/git'
require_relative 'git_hooks/config_file'
require_relative 'git_hooks/installer'
require_relative 'git_hooks/validator'
require_relative 'git_hooks/executor'
require_relative 'git_hooks/rspec_executor'
require_relative 'git_hooks/rubocop_validator'
require_relative 'git_hooks/trailing_whitespace_validator'

require_relative 'git_hooks/exceptions'
require_relative 'git_hooks/pre_commit'

module GitHooks
  HOOK_SAMPLE_FILE = 'hook.sample'
  HOOKS = %w(
    applypatch_msg pre_applypatch post_applypatch pre_commit prepare_commit_msg
    commit_msg post_commit pre_rebase post_checkout post_merge pre_receive
    update post_receive post_update pre_auto_gc post_rewrite pre_push
  )

  class << self
    attr_writer :configurations

    def configurations
      @configurations ||= Configurations.new
    end

    def base_path
      File.expand_path('../..', __FILE__)
    end
  end
end
