# -*- encoding : utf-8 -*-
module GitHooks
  class ConfigFile
    def initialize(path)
      @content = YAML.load_file(path)
    rescue Errno::ENOENT
      @content = {}
    end

    def pre_commits
      content.fetch('pre_commits') { [] }
    end

    def content
      @content || { 'pre_commits' => [] }
    end
  end
end
