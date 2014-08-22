module GitHooks
  class Validator
    attr_accessor :hook, :configurations

    def self.validate_all!(configurations = GitHooks.configurations)
      GitHooks::HOOKS.each do |hook|
        Validator.new(hook, configurations).validate!
      end
    end

    def initialize(hook, configurations)
      @hook, @configurations = hook, configurations
    end

    def validate!
      fail Exceptions::MissingHook, hook if hook_configured? && not_installed?
    end

    private

    def not_installed?
      !Installer.new(hook).installed?
    end

    def hook_configured?
      configurations.send(hook).any?
    end
  end
end
