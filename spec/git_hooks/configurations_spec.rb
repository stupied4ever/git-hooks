module GitHooks
  describe Configurations do
    describe '.default' do
      subject(:default) { described_class.default }

      describe '#config_file' do
        subject { default.config_file }

        it { is_expected.to eq('git_hooks.yml') }
      end

      describe '#git_folder' do
        subject { default.git_folder }

        it { is_expected.to eq('.') }
      end
    end
  end
end
