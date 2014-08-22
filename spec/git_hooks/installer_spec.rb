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
      allow(installer).to receive(:installed?).and_return(false)
      allow(FileUtils).to receive(:symlink).and_return(true)
    end

    it 'creates symlink' do
      expect(FileUtils)
        .to receive(:symlink)
        .with(hook_real_path, git_hook_path, force: false)

      install
    end

    it { is_expected.to be_truthy }

    context 'when there is a unknow hook' do
      before do
        allow(FileUtils).to receive(:symlink).and_raise(Errno::EEXIST)
      end

      it 'raises an error' do
        expect { install }.to raise_error(
          GitHooks::Exceptions::UnknowHookPresent
        )
      end
    end

    context 'when there is a unknow hook but I want to force installation' do
      subject(:install) { installer.install true }

      it 'creates symlink with force option' do
        expect(FileUtils)
          .to receive(:symlink)
          .with(hook_real_path, git_hook_path, force: true)

        install
      end

      it { is_expected.to be_truthy }
    end

    context 'when hook is already installed' do
      before do
        allow(installer).to receive(:installed?).and_return(true)
      end

      it 'does not create symlink' do
        expect(FileUtils)
          .to_not receive(:symlink)

        install
      end

      it { is_expected.to be_truthy }
    end
  end

  describe '.installed?' do
    subject(:installed?) { installer.installed? }

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
