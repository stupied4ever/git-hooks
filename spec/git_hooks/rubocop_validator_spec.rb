module GitHooks
  describe RubocopValidator do
    subject(:rubocop_validator) { described_class.new }

    describe '#errors?' do
      subject(:errors?) { rubocop_validator.errors?(files) }

      context 'with files' do
        let(:files) { %w(a.rb b.rb) }

        let(:rubocop_command) do
          "rubocop #{files.join(' ')} --force-exclusion"
        end

        before do
          allow(rubocop_validator).to receive(:system).and_return(true)
        end

        it 'call rubocop on system' do
          expect(rubocop_validator).to receive(:system).with(rubocop_command)
          errors?
        end

        context 'when some file has offences' do
          before do
            allow(rubocop_validator).to receive(:system).and_return(false)
          end

          it { is_expected.to be_truthy }
        end

        context 'when files has no offences' do
          before do
            allow(rubocop_validator).to receive(:system).and_return(true)
          end

          it { is_expected.to be_falsy }
        end
      end

      context 'with empty files array' do
        let(:files) { [] }

        it { is_expected.to be_falsy }
      end
    end
  end
end
