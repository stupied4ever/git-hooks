module GitHooks
  class Installer
    attr_accessor :hook

    HOOK_SAMPLE_FILE = 'hook.sample'

    def initialize(hook)
      @hook = hook
    end

    def install
      File.symlink(hook_template_path, File.join('.git', 'hooks', hook))
    end

    def hook_installed?
      hook_file = File.join(Dir.pwd, '.git', 'hooks', hook)

      File.symlink?(hook_file) && File.realpath(hook_file) == hook_template_path
    end

    private

    def hook_template_path
      File.join(GitHooks.base_path, HOOK_SAMPLE_FILE)
    end
  end
end
