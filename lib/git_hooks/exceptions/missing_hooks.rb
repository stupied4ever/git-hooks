# -*- encoding : utf-8 -*-
module GitHooks
  module Exceptions
    class MissingHook < RuntimeError
      def initialize(hook)
        super "Please install #{hook} hook."
      end
    end
  end
end
