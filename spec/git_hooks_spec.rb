describe GitHooks do
  describe '#validate_hooks!' do
    subject { -> { described_class.validate_hooks! } }

    before { GitHooks.configurations = configs }

    let(:configs) do
      instance_double(GitHooks::Configurations, pre_commits: pre_commits)
    end

    let(:pre_commits) { [] }

    it { is_expected.to_not raise_error }

    context 'with pre-commit hooks configured' do
      let(:pre_commits) { %w(foo bar) }
      let(:hook_installed?) { true }

      before do
        allow(GitHooks).to receive(:hook_installed?).and_return(hook_installed?)
      end

      it { is_expected.to_not raise_error }

      context 'but without pre-commit installed' do
        let(:hook_installed?) { false }

        let(:message) { 'Please install pre-commit hook.' }

        it do
          is_expected.to raise_error(GitHooks::Exceptions::MissingHook, message)
        end
      end
    end
  end

  describe '.base_path' do
    subject { described_class.base_path }

    it "has gem's root path" do
      is_expected.to eq(
        File.absolute_path(
          File.join(File.expand_path(__FILE__), '..', '..')
        )
      )
    end
  end

  describe '.configurations' do
    subject(:configurations) { described_class.configurations }

    before do
      GitHooks.configurations = nil
      allow(GitHooks::Configurations).to receive(:new).and_return(configs)
    end

    let(:configs) { instance_double(GitHooks::Configurations) }

    it 'creates with default params' do
      expect(GitHooks::Configurations).to receive(:new).with(no_args)

      is_expected.to eq(configs)
    end
  end

  describe 'configurations=' do
    subject(:set_configurations) { described_class.configurations = configs }

    let(:configs) { instance_double(GitHooks::Configurations) }

    before do
      allow(GitHooks::Configurations).to receive(:new).and_return(nil)
    end

    it 'updates configurations' do
      expect { set_configurations }.to change {
        GitHooks.configurations
      }.to(configs)

      is_expected.to eq(configs)
    end
  end

  describe '.hook_installed?' do
    subject { described_class.hook_installed?(hook) }

    let(:hook) { 'pre-commit' }
    let(:hook_real_path) { File.join(GitHooks.base_path, 'hook.sample') }
    let(:symlink?) { true }

    before do
      allow(File).to receive(:symlink?).and_return(symlink?)
      allow(File).to receive(:realpath).and_return(hook_real_path)
    end

    it { is_expected.to be_truthy }

    context 'when file is not a symlink' do
      let(:symlink?) { false }

      it { is_expected.to be_falsy }
    end

    context 'when is not the GitHooks file' do
      before do
        allow(File).to receive(:realpath).and_return('/tmp/foo')
      end

      it { is_expected.to be_falsy }
    end
  end
end
