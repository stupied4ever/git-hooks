require_relative 'pre_commit/rubocop'
require_relative 'pre_commit/prevent_master'

module GitHooks
  module PreCommit
    def self.validate
      PreventMaster.new.validate
      Rubocop.new.validate
    end
  end
end
