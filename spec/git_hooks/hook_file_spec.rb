module GitHooks
  describe HookFile do
    subject(:hook_file) { described_class.new(path) }

    let(:path) { '' }
    let(:content) { { pre_commits: pre_commits }.to_yaml.to_s }
    let(:pre_commits) { %w(foo bar) }

    before do
      allow(File).to receive(:read).and_return(content)
    end

    describe '#pre_commits' do
      subject { hook_file.pre_commits }

      it 'has the pre commits specified on hook file' do
        is_expected.to eq(%w(foo bar))
      end
    end
  end
end
