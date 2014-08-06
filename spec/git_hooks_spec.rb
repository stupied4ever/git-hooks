# -*- encoding : utf-8 -*-
describe GitHooks do
  describe '#validate_hooks!' do
    subject { -> { described_class.validate_hooks! } }

    before { GitHooks.configurations = configs }

    let(:configs) do
      GitHooks::Configurations.new(config_file: config_file)
    end

    let(:config_file) do
      GitHooks::ConfigFile.new(fixture_path('git_hooks.yml'))
    end

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
    subject(:set_configurations) do
      described_class.configurations = other_configs
    end

    let(:configs) { instance_double(GitHooks::Configurations) }
    let(:other_configs) { instance_double(GitHooks::Configurations) }

    before do
      described_class.configurations = configs
    end

    it 'updates configurations' do
      expect { set_configurations }.to change {
        GitHooks.configurations
      }.from(configs).to(other_configs)
    end
  end

  describe '.install' do
    subject(:install) { described_class.install(hook) }

    let(:hook) { 'pre-commit' }
    let(:hook_real_path) { File.join(GitHooks.base_path, 'hook.sample') }
    let(:git_hook_path) { ".git/hooks/#{hook}" }

    before do
      allow(File).to receive(:symlink).and_return(true)
    end

    it 'creates symlink' do
      expect(File)
        .to receive(:symlink)
        .with(hook_real_path, git_hook_path)
      install
    end

    it { is_expected.to be_truthy }
  end

  describe '.hook_installed?' do
    subject(:installed?) { described_class.hook_installed?(hook) }

    let(:hook) { 'pre-commit' }
    let(:hook_real_path) { File.join(GitHooks.base_path, 'hook.sample') }
    let(:symlink?) { true }

    let(:absolute_path) { File.join(GitHooks.base_path, '.git', 'hooks', hook) }

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
