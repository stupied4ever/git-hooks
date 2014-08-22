module GitHooks
  module PreCommit
    describe TrailingWhitespace do
      subject(:whitespace) do
        described_class.new(git_repository, whitespace_validator)
      end

      let(:git_repository) do
        instance_double(GitHooks::Git, added_or_modified: added_or_modified)
      end

      let(:whitespace_validator) do
        instance_double(GitHooks::TrailingWhitespaceValidator, errors?: errors?)
      end

      let(:added_or_modified) { [] }
      let(:errors?) { false }

      describe '#validate' do
        subject(:validate) { whitespace.validate  }

        let(:added_or_modified) { [ruby_file, 'foo.txt'] }
        let(:ruby_file) { 'foo.rb' }

        it 'only validates ruby files' do
          expect(whitespace_validator)
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

        let(:whitespace) { instance_double(TrailingWhitespace) }
        let(:git) { instance_double(Git) }
        let(:whitespace_validator) do
          instance_double(TrailingWhitespaceValidator)
        end

        before do
          allow(described_class).to receive(:new).and_return(whitespace)
          allow(whitespace).to receive(:validate).and_return(nil)

          allow(GitHooks).to receive(:git_repository).and_return(git)
          allow(TrailingWhitespaceValidator).to receive(:new)
            .and_return(whitespace_validator)
        end

        it 'creates object with GitHooks.git_repository' do
          expect(TrailingWhitespace).to receive(:new)
            .with(git, whitespace_validator)

          validate
        end

        it 'validates' do
          expect(whitespace).to receive(:validate)

          validate
        end
      end
    end
  end
end
