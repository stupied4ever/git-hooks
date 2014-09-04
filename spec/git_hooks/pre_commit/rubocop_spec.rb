module GitHooks
  module PreCommit
    describe Rubocop do
      subject(:rubocop) do
        described_class.new(git_repository, rubocop_validator)
      end

      let(:git_repository) do
        instance_double(GitHooks::Git, added_or_modified: added_or_modified)
      end

      let(:rubocop_validator) do
        instance_double(GitHooks::RubocopValidator, errors?: errors?)
      end

      let(:added_or_modified) { [] }
      let(:errors?) { false }

      describe '#validate' do
        subject(:validate) { rubocop.validate  }

        let(:added_or_modified) { [ruby_file, 'foo.txt'] }
        let(:ruby_file) { 'foo.rb' }

        it 'only validates ruby files' do
          expect(rubocop_validator)
            .to receive(:errors?)
            .with([ruby_file])
          validate
        end

        context 'with errors' do
          let(:errors?) { true }

          before do
            allow($stderr).to receive(:write).and_return('')
          end

          it { expect(-> { validate }).to raise_error(SystemExit) }
        end

        context 'without errors' do
          let(:errors?) { false }

          it { expect(-> { validate }).to_not raise_error }
        end
      end

      describe '.validate' do
        subject(:validate) { described_class.validate }

        let(:rubocop) { instance_double(Rubocop) }
        let(:rubocop_validator) { instance_double(RubocopValidator) }

        let(:git) { GitHooks.configurations.git_repository }

        before do
          allow(described_class).to receive(:new).and_return(rubocop)
          allow(rubocop).to receive(:validate).and_return(nil)

          allow(RubocopValidator).to receive(:new).and_return(rubocop_validator)
        end

        it 'creates object with git_repository and rubocop_validator' do
          expect(Rubocop).to receive(:new).with(git, rubocop_validator)

          validate
        end

        it 'validates' do
          expect(rubocop).to receive(:validate)

          validate
        end
      end
    end
  end
end
