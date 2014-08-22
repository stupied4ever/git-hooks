describe GitHooks do
  describe '#validate_hooks!' do
    subject { -> { described_class.validate_hooks! } }

    before do
      allow(GitHooks::Installer)
        .to receive(:new)
        .with(GitHooks::PRE_COMMIT)
        .and_return(installer)

      GitHooks.configurations = configs
    end

    let(:configs) do
      GitHooks::Configurations.new(config_file: config_file)
    end

    let(:config_file) do
      GitHooks::ConfigFile.new(fixture_path('git_hooks.yml'))
    end

    let(:installed?) { true }
    let(:installer) { instance_double(GitHooks::Installer) }

    before do
      allow(installer).to receive(:installed?).and_return(installed?)
    end

    it { is_expected.to_not raise_error }

    context 'but without pre-commit installed' do
      let(:installed?) { false }

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

    before { GitHooks.configurations = nil }

    let(:configs) { instance_double(GitHooks::Configurations) }

    it 'creates with default params' do
      expect(GitHooks::Configurations)
        .to receive(:new)
        .with(no_args)
        .and_return(configs)

      is_expected.to eq(configs)
    end
  end

  describe 'configurations=' do
    subject(:set_configurations) { GitHooks.configurations = configs }

    let(:configs) { instance_double(GitHooks::Configurations) }

    before do
      GitHooks.configurations = nil
      allow(GitHooks::Configurations).to receive(:new).and_return(nil)
    end

    it 'updates configurations' do
      expect { set_configurations }.to change {
        GitHooks.configurations
      }.to(configs)
    end
  end
end
