describe GitHooks::Executor do
  SimplePreCommitHook = Class.new

  subject(:executor) { described_class.new(hook, config_file) }

  let(:hook) { 'pre_commit' }

  let(:config_file) do
    GitHooks::ConfigFile.new(fixture_path('pre_commit_hook.yml'))
  end

  describe '#execute!' do
    subject(:execute_hook) { executor.execute! }

    it 'executes the hook' do
      expect(SimplePreCommitHook).to receive(:validate)

      execute_hook
    end
  end
end
