module GitHooks
  describe ConfigFile do
    subject(:config) { described_class.new(path) }

    let(:path) { 'some-not-existent-file' }
    let(:content) { { 'pre_commits' => pre_commits } }
    let(:pre_commits) { %w(foo bar) }

    describe '#pre_commits' do
      subject { config.pre_commits }

      it { is_expected.to eq([]) }

      context 'when the given file exists' do
        before do
          allow(YAML).to receive(:load_file).and_return(content)
        end

        it 'has the pre commits specified on hook file' do
          is_expected.to eq(%w(foo bar))
        end
      end
    end
  end
end
