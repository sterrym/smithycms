require 'spec_helper'

describe Smithy::ContentBlockTemplate do
  it { should allow_mass_assignment_of :name }
  it { should allow_mass_assignment_of :content }

  it { should validate_presence_of :name }
  it { should_not validate_presence_of(:content) }
  context "on update" do
    let(:content_block) { FactoryGirl.create(:content_block) }
    let!(:content_block_template) { FactoryGirl.create(:content_block_template, :content_block => content_block) }
    subject { FactoryGirl.create(:content_block_template, :content_block => content_block) }
    it { should validate_uniqueness_of(:name).scoped_to(:content_block_id) }
    it { should validate_presence_of :content }
  end

  it { should belong_to :content_block }
end
