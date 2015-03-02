module GitHooks
  describe ConfigFile do
    subject(:config) { described_class.new(path) }

    let(:path) { 'some-not-existent-file' }
    let(:content) { { 'pre_commits' => pre_commits } }
    let(:pre_commits) do
      {
        'Rubocop' => { 'use_stash' => true },
        'Rspec' => nil
      }
    end

    describe '#pre_commits' do
      subject { config.pre_commits }

      let(:path) { fixture_path('git_hooks.yml') }

      it 'has the pre commits specified on hook file' do
        is_expected.to eq(pre_commits)
      end

      context 'when the given file does not exist' do
        let(:path) { 'some-non-existing-file' }

        it { is_expected.to eq([]) }
      end
    end
  end
end
