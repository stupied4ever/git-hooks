require_relative 'hook_installer'

module GitHooks
  class Installer
    def initialize(*hooks, ruby_path: nil)
      @installers = hooks.map do |hook|
        GitHooks::HookInstaller.new(hook, ruby_path)
      end
    end

    def install(force = false)
      @installers.each { |i| i.install(force) }
    end

    def installed?
      @installers.all?(&:installed?)
    end
  end
end
