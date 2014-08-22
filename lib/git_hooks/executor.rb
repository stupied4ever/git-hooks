module GitHooks
  class Executor
    attr_accessor :hook, :configurations

    def initialize(hook, configurations = GitHooks.configurations)
      @hook, @configurations = prepare(hook), configurations
    end

    def execute!
      hooks_instances.each do |hook_instance|
        GitHooks.const_get(hook_instance).validate
      end
    end

    private

    def hooks_instances
      configurations.send(hook)
    end

    def prepare(hook)
      hook.gsub('-', '_')
    end
  end
end
