module GitHooks
  describe Configurations do
    subject(:configurations) { described_class.new }

    before do
      allow(ConfigFile).to receive(:new).and_return(default_config_file)
      allow(Git).to receive(:new).and_return(repository)
    end

    let(:default_config_file) { ConfigFile.new(fixture_path('git_hooks.yml')) }
    let(:repository) { instance_double(Git) }

    describe '#pre_commit' do
      subject { configurations.pre_commit }

      it { is_expected.to eq(default_config_file.pre_commit) }
    end

    describe '#config_file' do
      subject(:config_file) { configurations.config_file }

      let(:config_path) { '.git_hooks.yml' }

      it { is_expected.to eq(default_config_file) }

      it 'creates a config file with config_path' do
        expect(ConfigFile).to receive(:new).with(config_path)

        configurations
      end

      context 'with a config_path set' do
        let(:configurations) { described_class.new(config_file: config_file) }

        let(:config_file) { double }

        it 'does not creates a config file' do
          expect(ConfigFile).to_not receive(:new)

          configurations
        end

        it { is_expected.to eq(config_file) }
      end
    end

    describe '#git_repository' do
      subject(:git_repository) { configurations.git_repository }

      let(:git_folder) { '.' }

      it { is_expected.to eq(repository) }

      it 'creates git repository with git folder' do
        expect(Git).to receive(:new).with(git_folder)

        git_repository
      end

      context 'with a git_repository set' do
        let(:git_repository) do
          described_class.new(git_repository: repository)
        end

        it 'does not creates a git repository' do
          expect(Git).to_not receive(:new)

          git_repository
        end

        it { is_expected.to eq(repository) }
      end
    end
  end
end
