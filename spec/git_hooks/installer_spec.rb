describe GitHooks::Installer do
  subject(:installer) { described_class.new(hook) }

  let(:hook) { 'pre-commit' }

  let(:hook_real_path) do
    File.join(GitHooks.base_path, 'hook.sample')
  end

  let(:absolute_path) do
    File.join(GitHooks.base_path, '.git', 'hooks', hook)
  end

  let(:git_hook_path) { ".git/hooks/#{hook}" }

  describe '.install' do
    subject(:install) { installer.install }

    before do
      allow(File).to receive(:symlink).and_return(true)
    end

    it 'creates symlink' do
      expect(File).to receive(:symlink).with(hook_real_path, git_hook_path)

      install
    end

    it { is_expected.to be_truthy }
  end

  describe '.hook_installed?' do
    subject(:installed?) { installer.hook_installed? }

    let(:symlink?) { true }

    before do
      allow(File).to receive(:symlink?).and_return(symlink?)
      allow(File).to receive(:realpath).and_return(hook_real_path)
    end

    it 'validates file is a symlink' do
      expect(File).to receive(:symlink?).with(absolute_path)
      installed?
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
