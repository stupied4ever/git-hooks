# -*- encoding : utf-8 -*-
module GitHooks
  describe Git do
    subject(:git) { described_class.new(working_folder) }

    let(:working_folder) { 'some folder' }

    describe '#working_folder' do
      subject { git.working_folder }

      it { is_expected.to eq(working_folder) }
    end

    describe '#repository' do
      subject(:opened_repository) { git.repository }

      let(:repository) { instance_double(::Git::Base) }

      before do
        allow(::Git).to receive(:open).and_return(repository)
      end

      it 'open git repository' do
        expect(::Git).to receive(:open).with(working_folder)
        opened_repository
      end

      it { is_expected.to eq(repository) }
    end

    describe '#added_or_modified' do
      subject(:added_or_modified) { git.added_or_modified }

      let(:repository) { instance_double(::Git::Base, status: status) }

      let(:status) do
        instance_double(::Git::Status, added: added, changed: changed)
      end

      let(:added) { { foo: 'bar' } }
      let(:changed) { { bar: 'foo' } }

      before do
        allow(::Git).to receive(:open).and_return(repository)
      end

      it 'merges added and modified' do
        is_expected.to eq([:foo, :bar])
      end
    end

    describe '#clean?' do
      subject(:clean?) { git.clean? }

      let(:repository) { instance_double(::Git::Base, status: status) }

      let(:status) do
        instance_double(
          ::Git::Status,
          added: added, changed: changed, deleted: deleted, untracked: untracked
        )
      end

      let(:added) { Hash.new }
      let(:changed) { Hash.new }
      let(:deleted) { Hash.new }
      let(:untracked) { Hash.new }

      before do
        allow(::Git).to receive(:open).and_return(repository)
      end

      it { is_expected.to be_truthy }

      context 'with some added file' do
        let(:added) { { foo: 'bar' } }

        it { is_expected.to be_falsy }
      end

      context 'with some changed file' do
        let(:changed) { { foo: 'bar' } }

        it { is_expected.to be_falsy }
      end

      context 'with some deleted file' do
        let(:deleted) { { foo: 'bar' } }

        it { is_expected.to be_falsy }
      end

      context 'with some untracked file' do
        let(:untracked) { { foo: 'bar' } }

        it { is_expected.to be_falsy }
      end
    end

    describe '#current_branch' do
      subject { git.current_branch }

      let(:repository) { instance_double(::Git::Base, current_branch: branch) }
      let(:branch) { 'some-branch' }

      before do
        allow(::Git).to receive(:open).and_return(repository)
        allow(git).to receive(:current_branch).and_return(branch)
      end

      it 'returns the current branch' do
        is_expected.to eq('some-branch')
      end
    end
  end
end
