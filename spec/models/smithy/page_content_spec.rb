require 'spec_helper'

describe Smithy::PageContent do
  it { should allow_mass_assignment_of :label }
  it { should allow_mass_assignment_of :container }
  it { should allow_mass_assignment_of :content_block_type }
  it { should allow_mass_assignment_of :content_block_attributes }
  it { should allow_mass_assignment_of :content_block_template_id }
  it { should allow_mass_assignment_of :position }

  it { should validate_presence_of :label }
  it { should validate_presence_of :container }
  it { should_not validate_presence_of(:content_block) }
  it { should_not validate_presence_of(:content_block_template) }
  context "on update" do
    subject { FactoryGirl.create(:page_content) }
    it { should validate_presence_of :content_block }
    it { should validate_presence_of(:content_block_template) }
  end

  it { should accept_nested_attributes_for(:content_block).allow_destroy(true) }

  it { should belong_to(:page) }
  it { should belong_to(:content_block) }
  it { should belong_to(:content_block_template) }

  describe "#render" do
    let(:content_block_template) { FactoryGirl.create(:content_block_template, :content => '{{ content }}' ) }
    let(:content) { FactoryGirl.create(:content, :content => "This is the content") }
    subject { FactoryGirl.create(:page_content, :content_block => content, :content_block_template => content_block_template).render }
    it { should_not be_nil }
    it { should == "This is the content"}
  end

  describe "#templates" do
    let(:content_block) { FactoryGirl.create(:content_block, :name => 'Content' ) }
    let(:content_block_template1) { FactoryGirl.create(:content_block_template, :content => '{{ content }}', :content_block => content_block ) }
    let(:content_block_template2) { FactoryGirl.create(:content_block_template, :content => '<div>{{ content }}', :content_block => content_block ) }
    let(:content_block_template3) { FactoryGirl.create(:content_block_template, :content => '<div>{{ content }}' ) }
    let(:content) { FactoryGirl.create(:content, :content => "This is the content") }
    subject { FactoryGirl.create(:page_content, :content_block => content, :content_block_template => content_block_template1).templates }
    it { should == [content_block_template1, content_block_template2].sort_by{|cb| cb.name } }
  end

  describe "#to_liquid" do
    let(:content) { FactoryGirl.create(:content, :content => "This is the content") }
    subject { FactoryGirl.create(:page_content, :content_block => content).to_liquid }
    it { should == content.attributes }
  end
end
