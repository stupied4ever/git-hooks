require_relative 'pre_commit/prevent_debugger'
require_relative 'pre_commit/prevent_master'
require_relative 'pre_commit/rspec'
require_relative 'pre_commit/rubocop'
require_relative 'pre_commit/whitespace'

module GitHooks
  module PreCommit
  end
end
