module GitHooks
  module Exceptions
    class MissingHook < RuntimeError
      def initialize(hook)
        super "Please install #{hook} hook with `git_hooks install #{hook}'"
      end
    end
  end
end
