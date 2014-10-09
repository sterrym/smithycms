require 'rails_helper'

RSpec.describe Smithy::PageContent, :type => :model do
  it { is_expected.to validate_presence_of :label }
  it { is_expected.to validate_presence_of :container }
  it { is_expected.to validate_presence_of :content_block_type }
  it { is_expected.not_to validate_presence_of(:content_block) }
  it { is_expected.not_to validate_presence_of(:content_block_template) }
  context "on update" do
    subject { create(:page_content) }
    it { is_expected.to validate_presence_of :content_block }
    it { is_expected.to validate_presence_of(:content_block_template) }
  end

  it { is_expected.to accept_nested_attributes_for(:content_block).allow_destroy(true) }

  it { is_expected.to belong_to(:page) }
  it { is_expected.to belong_to(:content_block) }
  it { is_expected.to belong_to(:content_block_template) }

  describe "#render" do
    let(:liquid_context) { ::Liquid::Context.new }
    let(:content_block_template) { build(:content_block_template, :content => '{{ content }}' ) }
    let(:content) { build(:content, :content => "This is the content") }
    subject { build(:page_content, :content_block => content, :content_block_template => content_block_template).render(liquid_context) }
    it { is_expected.not_to be_nil }
    it { is_expected.to eq("This is the content")}
  end

  describe "#templates" do
    let!(:content_block_template1) { create(:content_block_template, :content => '{{ content }}', :content_block => nil ) }
    let!(:content_block_template2) { create(:content_block_template, :content => '<div>{{ content }}</div>', :content_block => nil ) }
    let!(:content_block_template3) { create(:content_block_template, :content => '{{ content }}</div>', :content_block => nil ) }
    let!(:content_block) { create(:content_block, :name => 'Content', :templates => [content_block_template1, content_block_template2]) }
    let!(:content) { create(:content, :content => "This is the content") }
    let(:page_content) { create(:page_content, :content_block => content, :content_block_template => content_block_template1) }
    subject { page_content.templates }
    it { is_expected.to include content_block_template1 }
    it { is_expected.to include content_block_template2 }
    it { is_expected.not_to include content_block_template3 }
 end

  describe "#to_liquid" do
    let(:content) { build(:content, :content => "This is the content") }
    subject { build(:page_content, :content_block => content).to_liquid }
    it { is_expected.to eq(content.to_liquid) }
  end
end
