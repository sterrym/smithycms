shared_context "acts like a content block" do
  it { should have_one :page_content }
  it { should have_one(:page).through(:page_content) }
  specify { Smithy::ContentBlocks::Registry.content_blocks.should include(subject.class.to_s.demodulize)}
end
