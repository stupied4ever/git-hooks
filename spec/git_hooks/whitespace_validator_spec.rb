module GitHooks
  describe WhitespaceValidator do
    subject(:whitespace_validator) { described_class.new }

    let(:file_names) { %w(a.rb b.rb) }
    let(:files) { [file] * 2 }
    let(:file) { instance_double(File) }

    before do
      allow(File).to receive(:open).and_return(file)
      allow(file).to receive(:read).and_return('I no have no whitespace!')
    end

    describe '#errors?' do
      subject(:errors?) { whitespace_validator.errors?(files) }

      context 'with files' do
        context 'when files has no offences' do

          it { is_expected.to be_falsy }
        end

        context 'when some file has offences' do
          before do
            allow(file).to receive(:read).and_return('My text editor sucks   ')
          end

          it { is_expected.to be_truthy }
        end
      end

      context 'with empty files array' do
        let(:files) { [] }

        it { is_expected.to be_falsy }
      end
    end
  end
end
