require 'spec_helper'

describe Smithy::ContentBlockTemplate do
  it { should validate_presence_of :name }
  it { should validate_presence_of(:content) }
  context "on update" do
    let(:content_block) { create(:content_block) }
    let!(:content_block_template) { create(:content_block_template, :content_block => content_block) }
    subject { create(:content_block_template, :content_block => content_block) }
    it { should validate_uniqueness_of(:name).scoped_to(:content_block_id) }
  end

  it { should belong_to :content_block }
end
