require 'spec_helper'

describe Smithy::ContentBlockTemplate, :type => :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of(:content) }
  context "on update" do
    let(:content_block) { create(:content_block) }
    let!(:content_block_template) { create(:content_block_template, :content_block => content_block) }
    subject { create(:content_block_template, :content_block => content_block) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:content_block_id) }
  end

  it { is_expected.to belong_to :content_block }
end
