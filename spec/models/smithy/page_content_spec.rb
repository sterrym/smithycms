require 'spec_helper'

describe Smithy::PageContent do
  it { should allow_mass_assignment_of :label }
  it { should allow_mass_assignment_of :container }
  it { should allow_mass_assignment_of :content_block }
  it { should allow_mass_assignment_of :position }

  it { should validate_presence_of :label }
  it { should validate_presence_of :container }
  it { should_not validate_presence_of(:content_block) }
  context "on update" do
    subject { FactoryGirl.create(:page_content) }
    it { should validate_presence_of :content_block }
  end

  it { should accept_nested_attributes_for(:content_block).allow_destroy(true) }

  it { should belong_to(:page) }
  it { should belong_to(:content_block) }
end
