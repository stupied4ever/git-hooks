require_relative 'pre_commit/prevent_master'
require_relative 'pre_commit/rspec'
require_relative 'pre_commit/rubocop'

module GitHooks
  module PreCommit
    def self.validate
      PreventMaster.new.validate
      Rubocop.new.validate
      Rspec.new.validate
    end
  end
end
