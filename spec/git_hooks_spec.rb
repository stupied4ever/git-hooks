describe GitHooks do
  it 'know all hooks' do
    expect(described_class::HOOKS).to eq(
      %w(
        applypatch_msg pre_applypatch post_applypatch pre_commit
        prepare_commit_msg commit_msg post_commit pre_rebase post_checkout
        post_merge pre_receive update post_receive post_update pre_auto_gc
        post_rewrite pre_push
      )
    )
  end

  describe '.base_path' do
    subject { described_class.base_path }

    it "has gem's root path" do
      is_expected.to eq(
        File.absolute_path(
          File.join(File.expand_path(__FILE__), '..', '..')
        )
      )
    end
  end

  describe '.configurations' do
    subject(:configurations) { described_class.configurations }

    before { GitHooks.configurations = nil }

    let(:configs) { instance_double(GitHooks::Configurations) }

    it 'creates with default params' do
      expect(GitHooks::Configurations)
        .to receive(:new)
        .with(no_args)
        .and_return(configs)

      is_expected.to eq(configs)
    end
  end

  describe 'configurations=' do
    subject(:set_configurations) { GitHooks.configurations = configs }

    let(:configs) { instance_double(GitHooks::Configurations) }

    before do
      GitHooks.configurations = nil
      allow(GitHooks::Configurations).to receive(:new).and_return(nil)
    end

    it 'updates configurations' do
      expect { set_configurations }.to change {
        GitHooks.configurations
      }.to(configs)
    end
  end
end
