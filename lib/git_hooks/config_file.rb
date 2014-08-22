require 'ostruct'

module GitHooks
  class ConfigFile < OpenStruct
    attr_accessor :path

    def initialize(path)
      @path = path

      super(load_file)
    end

    private

    def load_file
      content = YAML.load_file(path)
      default_config.merge(content)
    rescue Errno::ENOENT
      default_config
    end

    def default_config
      GitHooks::HOOKS.each_with_object({}) do |hook, hash|
        hash[hook.to_sym] = []
      end
    end
  end
end
