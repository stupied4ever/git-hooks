require 'git'

require_relative 'git_hooks/configurations'
require_relative 'git_hooks/git'
require_relative 'git_hooks/rspec_executor'
require_relative 'git_hooks/rubocop_validator'

require_relative 'git_hooks/pre_commit'

module GitHooks
  def self.configurations
    @configurations ||= Configurations.default
  end

  def self.git_repository
    Git.new(configurations.git_folder)
  end
end
