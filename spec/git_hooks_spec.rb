describe GitHooks do
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
    subject { described_class.configurations }

    it { is_expected.to eq(GitHooks::Configurations.default) }
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

  describe '.git_repository' do
    subject(:git) { described_class.git_repository }

    before { allow(GitHooks::Git).to receive(:new).and_return(git_repository) }

    let(:git_repository) { instance_double(GitHooks::Git) }

    it 'initialize git with `configuration#git_repository`' do
      expect(GitHooks::Git)
        .to receive(:new)
        .with(GitHooks.configurations.git_folder)

      git
    end

    it('returns git_repository') { is_expected.to eq(git_repository) }
  end
end
