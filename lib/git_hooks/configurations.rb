module GitHooks
  Configurations = Struct.new(:config_file, :git_folder) do
    def self.default
      new('git_hooks.yml', '.')
    end
  end
end
