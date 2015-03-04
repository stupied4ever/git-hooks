module GitHooks
  module Exceptions
    class UnknownHookPresent < RuntimeError
      def initialize(hook)
        super <<-HEREDOC
There is already a #{hook} hook installed.
If you want to override it, use the --force option.
HEREDOC
      end
    end
  end
end
