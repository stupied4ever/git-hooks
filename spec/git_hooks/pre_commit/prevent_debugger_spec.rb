module GitHooks
  module PreCommit
    describe PreventDebugger do
      subject(:prevent_debugger) { described_class.new git_repository }

      let(:git_repository) do
        instance_double(GitHooks::Git, added_or_modified: files)
      end

      let(:files) { ['some_file.rb'] }

      describe '#validate' do
        subject(:validate) { -> { prevent_debugger.validate } }

        let(:file_content) { 'this is a big file without' }

        before do
          allow(File)
            .to receive(:read)
            .with(files.first)
            .and_return(file_content)

          allow($stderr).to receive(:write).and_return('')
        end

        it { is_expected.to_not raise_error }

        %w(
          binding.pry
          binding.remote_pry
          save_and_open_page
          debugger
        ).each do |debugger_string|
          context "when has #{debugger_string}" do
            let(:file_content) { "this is a big file with #{debugger_string}" }

            it { is_expected.to raise_error(SystemExit) }
          end
        end
      end

      describe '.validate' do
        subject(:validate) { described_class.validate }

        let(:prevent_debugger) { instance_double(PreventDebugger) }
        let(:git) { instance_double(GitHooks::Git) }

        let(:configurations) do
          instance_double(Configurations, git_repository: git)
        end

        before do
          allow(GitHooks).to receive(:configurations).and_return(configurations)
          allow(described_class).to receive(:new).and_return(prevent_debugger)
          allow(prevent_debugger).to receive(:validate).and_return(nil)
        end

        it 'creates object with GitHooks.git_repository' do
          expect(PreventDebugger).to receive(:new).with(git)

          validate
        end

        it 'validates' do
          expect(prevent_debugger).to receive(:validate)

          validate
        end
      end
    end
  end
end
