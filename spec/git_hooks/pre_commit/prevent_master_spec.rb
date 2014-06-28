module GitHooks
  module PreCommit
    describe PreventMaster do
      subject(:prevent_master) { described_class.new git_repository }

      let(:git_repository) do
        instance_double(GitHooks::Git, current_branch: branch)
      end

      let(:branch) { 'some-branch' }

      describe '#validate' do
        subject(:validate) { -> { prevent_master.validate } }

        it { is_expected.to_not raise_error }

        context 'when current_branch is master' do
          let(:branch) { 'master' }

          before do
            allow($stderr).to receive(:write).and_return('')
          end
          it { is_expected.to raise_error(SystemExit) }
        end
      end

      describe '.validate' do
        subject(:validate) { described_class.validate }

        let(:prevent_master) { instance_double(PreventMaster) }
        let(:git) { instance_double(Git) }

        before do
          allow(GitHooks).to receive(:git_repository).and_return(git)
          allow(described_class).to receive(:new).and_return(prevent_master)
          allow(prevent_master).to receive(:validate).and_return(nil)
        end

        it 'creates object with GitHooks.git_repository' do
          expect(PreventMaster).to receive(:new).with(git)

          validate
        end

        it 'validates' do
          expect(prevent_master).to receive(:validate)

          validate
        end
      end
    end
  end
end
