RSpec.shared_context "acts like a content block" do
  it { is_expected.to have_many :page_contents }
  it { is_expected.to have_many(:pages).through(:page_contents) }
  specify { expect(Smithy::ContentBlocks::Registry.content_blocks).to include(subject.class.to_s.demodulize)}
end
