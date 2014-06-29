module GitHooks
  class HookFile
    attr_reader :content

    def initialize(path)
      @content = YAML.load(File.read(path))
    end

    def pre_commits
      content[:pre_commits]
    end
  end
end
