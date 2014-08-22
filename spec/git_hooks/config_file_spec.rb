module GitHooks
  describe ConfigFile do
    subject(:config) { described_class.new(path) }

    let(:path) { fixture_path('git_hooks.yml') }

    describe '#pre_commit' do
      subject { config.pre_commit }

      it 'has the pre commits specified on hook file' do
        is_expected.to eq(%w(foo bar))
      end

      context 'when the given file does not exist' do
        let(:path) { 'some-not-existent-file' }

        it { is_expected.to eq([]) }
      end
    end
  end
end
