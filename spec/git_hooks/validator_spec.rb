describe GitHooks::Validator do
  describe '.validate_all!' do
    subject(:validate) { described_class.validate_all!(config_file) }

    let(:config_file) do
      GitHooks::ConfigFile.new(fixture_path('git_hooks.yml'))
    end

    let(:validator) { instance_double(described_class) }

    GitHooks::HOOKS.each do |hook|
      before do
        allow(described_class).to receive(:new).and_return(validator)
        allow(validator).to receive(:validate!).and_return(true)
      end

      it "creates a validator for #{hook} and validate! it" do
        expect(described_class)
          .to receive(:new)
          .with(hook, config_file)
        expect(validator).to receive(:validate!)

        validate
      end
    end
  end

  describe '#validate_hook!' do
    subject { -> { described_class.new(hook, configurations).validate! } }

    before do
      allow(GitHooks::Installer)
        .to receive(:new)
        .with(hook)
        .and_return(installer)
    end

    let(:hook) { 'pre_commit' }

    let(:configurations) do
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

      let(:message) { "Please install #{hook} hook." }

      it do
        is_expected.to raise_error(GitHooks::Exceptions::MissingHook, message)
      end
    end
  end
end
