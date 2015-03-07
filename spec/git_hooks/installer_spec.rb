describe GitHooks::Installer do
  subject(:installer) { described_class.new(hook) }

  let(:hook) { 'pre-commit' }

  let(:hook_template_path) do
    File.join(GitHooks.base_path, 'hook.sample')
  end

  let(:hook_path) do
    File.join('.git', 'hooks', hook)
  end

  let(:git_hook_path) { ".git/hooks/#{hook}" }
  let(:file) { instance_double(File, write: true) }

  before do
    allow(File).to receive(:open).and_return(file)
    allow(FileUtils).to receive(:chmod).and_return(true)
  end

  describe '#install' do
    subject(:install) { installer.install }

    let(:installed?) { false }

    before do
      allow(installer).to receive(:installed?)
        .and_return(installed?)
    end

    it 'creates a new file' do
      expect(File).to receive(:open)
        .with(hook_path, 'w')

      expect(file).to receive(:write)
        .with(/GitHooks.execute_pre_commits/)

      install
    end

    it { is_expected.to be_truthy }

    context 'when there is a unknown hook but I want to force installation' do
      subject(:install) { installer.install(true) }

      let(:installed?) { true }

      it 'creates symlink with force option' do
        expect(File).to receive(:open)
          .with(hook_path, 'w')

        expect(file).to receive(:write)
          .with(/GitHooks.execute_pre_commits/)

        install
      end

      it { is_expected.to be_truthy }
    end
  end

  describe '#installed?' do
    subject(:installed?) { installer.installed? }

    let(:exists?) { true }

    before do
      allow(File).to receive(:exist?).and_return(exists?)
      allow(File).to receive(:read)
        .and_return('GitHooks.execute_pre_commits')
    end

    it do
      is_expected.to be_truthy
    end

    it do
      expect(File).to receive(:exist?).with(hook_path)
      installed?
    end

    context 'when the hook does not validate pre_commits' do
      before do
        allow(File).to receive(:read)
          .and_return('echo yolo')
      end

      it { is_expected.to be_falsy }
    end

    context 'when the hook file does not exist' do
      let(:exists?) { false }

      it { is_expected.to be_falsy }
    end
  end
end
