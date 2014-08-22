module GitHooks
  class Installer
    attr_accessor :hook

    HOOK_SAMPLE_FILE = 'hook.sample'

    def initialize(hook)
      @hook = hook
    end

    def install(force = false)
      return true if installed?

      FileUtils.symlink(
        hook_template_path,
        File.join('.git', 'hooks', hook_file_name),
        force: force
      )
    rescue Errno::EEXIST
      raise GitHooks::Exceptions::UnknowHookPresent, hook
    end

    def installed?
      hook_file = File.join(Dir.pwd, '.git', 'hooks', hook_file_name)

      File.symlink?(hook_file) && File.realpath(hook_file) == hook_template_path
    end

    private

    def hook_file_name
      hook.gsub('_', '-')
    end

    def hook_template_path
      File.join(GitHooks.base_path, HOOK_SAMPLE_FILE)
    end
  end
end
