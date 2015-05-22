module GitHooks
  class HookInstaller
    HOOK_SAMPLE_FILE = 'hook.sample'

    def initialize(hook, ruby_path)
      @hook = hook
      @ruby_path = ruby_path
    end

    def install(force = false)
      throw Exceptions::UnknownHookPresent.new(hook) if !force && installed?

      hook_script = hook_template
      hook_script.gsub!('/usr/bin/env ruby', ruby_path) if ruby_path

      puts "Writing to file #{hook_path}"
      File
        .open(hook_path, 'w')
        .write(hook_script)

      FileUtils.chmod(0775, hook_path)
    end

    def installed?
      File.exist?(hook_path) && hook_file_contains_hook_command?
    end

    private

    attr_accessor :hook, :ruby_path

    def hook_file_contains_hook_command?
      expected = /GitHooks.execute_#{Regexp.escape(@hook.gsub('-', '_'))}s/
      File.read(hook_path).match(expected)
    end

    def hook_template
      File.read(hook_template_path)
    end

    def hook_template_path
      File.join(GitHooks.base_path, HOOK_SAMPLE_FILE)
    end

    def hook_path
      File.join('.git', 'hooks', hook)
    end
  end
end
