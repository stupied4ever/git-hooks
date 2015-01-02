module GitHooks
  module PreCommit
    describe Rspec do
      subject(:rspec) { described_class.new(git_repository, rspec_executor) }

      let(:git_repository) do
        instance_double(GitHooks::Git, clean?: clean?)
      end

      let(:rspec_executor) do
        instance_double(GitHooks::RspecExecutor, errors?: errors?)
      end

      let(:errors?) { false }

      describe '#validate' do
        subject(:validate) { -> { rspec.validate } }

        let(:clean?) { true }

        it { is_expected.to_not raise_error }

        context 'with modified files' do
          let(:rspec_executor) do
            instance_double(GitHooks::RspecExecutor, errors?: errors?)
          end

          let(:clean?) { false }
          let(:errors?) { false }

          it { is_expected.to_not raise_error }

          context 'and some broken test' do
            let(:errors?) { true }

            before do
              allow($stderr).to receive(:write).and_return('')
            end

            it { is_expected.to raise_error(SystemExit) }
          end
        end
      end

      describe '.validate' do
        subject(:validate) { described_class.validate }

        let(:rspec) { instance_double(Rspec) }
        let(:rspec_executor) { instance_double(RspecExecutor) }

        let(:git) { GitHooks.configurations.git_repository }

        before do
          allow(described_class).to receive(:new).and_return(rspec)
          allow(rspec).to receive(:validate).and_return(nil)

          allow(RspecExecutor).to receive(:new).and_return(rspec_executor)
        end

        it 'creates object with git_repository and rspec_executor' do
          expect(Rspec).to receive(:new).with(git, rspec_executor)

          validate
        end

        it 'validates' do
          expect(rspec).to receive(:validate)

          validate
        end
      end
    end
  end
end
