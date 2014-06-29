module GitHooks
  class ConfigFile
    def initialize(path)
      @content = YAML.load_file(path)
    end

    def pre_commits
      content['pre_commits'] || []
    end

    def content
      @content || { 'pre_commits' => [] }
    end
  end
end
