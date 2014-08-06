# -*- encoding : utf-8 -*-
module GitHooks
  describe RspecExecutor do
    subject(:rspec_executor) { described_class.new }

    describe '#errors?' do
      subject(:errors?) { rspec_executor.errors? }

      let(:rspec_command) { 'bundle exec rspec --format=progress' }

      before do
        allow(rspec_executor).to receive(:system).and_return(true)
      end

      it 'call rubocop on system' do
        expect(rspec_executor).to receive(:system).with(rspec_command)
        errors?
      end

      context 'with broken test' do
        before do
          allow(rspec_executor).to receive(:system).and_return(false)
        end

        it { is_expected.to be_truthy }
      end

      context 'when files has no offences' do
        before do
          allow(rspec_executor).to receive(:system).and_return(true)
        end

        it { is_expected.to be_falsy }
      end
    end
  end
end
