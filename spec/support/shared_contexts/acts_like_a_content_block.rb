shared_context "acts like a content block" do
  it { should have_many :page_contents }
  specify { Smithy::ContentBlocks::Registry.content_blocks.should include(subject.class.to_s.demodulize)}
end
