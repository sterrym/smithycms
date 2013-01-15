require 'spec_helper'

describe Smithy::Content do
  include_context "acts like a content block" # see spec/support/shared_contexts
  it { should allow_mass_assignment_of :content }
  context "#markdown_content" do
    subject { FactoryGirl.create(:content).markdown_content }
    it { should_not be_blank }
  end
end
