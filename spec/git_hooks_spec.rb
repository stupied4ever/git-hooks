describe GitHooks do
  describe '.configurations' do
    subject { described_class.configurations }

    it { is_expected.to eq(GitHooks::Configurations.default) }
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
