describe GitHooks do
  subject(:git_hooks) { described_class }

  let(:configs) do
    GitHooks::Configurations.new(config_file: config_file)
  end

  let(:config_file) do
    GitHooks::ConfigFile.new(fixture_path('git_hooks.yml'))
  end

  before { GitHooks.configurations = configs }

  describe '#validate_hooks!' do
    subject { -> { git_hooks.validate_hooks! } }

    let(:installed?) { true }
    let(:installer) { instance_double(GitHooks::Installer) }

    before do
      allow(GitHooks::Installer)
        .to receive(:new)
        .with(GitHooks::PRE_COMMIT)
        .and_return(installer)
    end

    before do
      allow(installer).to receive(:installed?).and_return(installed?)
    end

    it { is_expected.to_not raise_error }

    context 'but without pre-commit installed' do
      let(:installed?) { false }

      let(:message) do
        "Please install pre-commit hook with `git_hooks install pre-commit'"
      end

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

    let(:configs) { double(:probe) }

    it 'creates with default params' do
      expect(GitHooks::Configurations)
        .to receive(:new)
        .with(no_args)
        .and_return(configs)

      is_expected.to eq(configs)
    end
  end

  describe 'configurations=' do
    subject { -> { GitHooks.configurations = configs } }

    let!(:configs) { double(:probe) }

    before { GitHooks.configurations = nil }
    after { GitHooks.configurations = nil }

    it 'updates configurations' do
      is_expected.to change { GitHooks.configurations }.to(configs)
    end
  end

  describe '#execute_pre_commits' do
    subject(:execute_pre_commits) { GitHooks.execute_pre_commits }

    let(:rubocop_options) do
      { 'use_stash' => true }
    end

    before do
      allow(GitHooks::PreCommit::Rspec).to receive(:validate)
      allow(GitHooks::PreCommit::Rubocop).to receive(:validate)
    end

    it 'instantiates each pre commit' do
      expect(GitHooks::PreCommit).to receive(:const_get)
        .with('Rubocop').and_call_original
      expect(GitHooks::PreCommit).to receive(:const_get)
        .with('Rspec').and_call_original

      execute_pre_commits
    end

    it 'validates the hook, passing its options when available' do
      expect(GitHooks::PreCommit::Rubocop).to receive(:validate)
        .with(rubocop_options)
      expect(GitHooks::PreCommit::Rspec).to receive(:validate)
        .with(no_args)

      execute_pre_commits
    end
  end
end
