require 'spec_helper'

describe Smithy::Content do
  include_context "acts like a content block" # see spec/support/shared_contexts
  context "#markdown_content" do
    subject { create(:content).markdown_content }
    it { should_not be_blank }
  end
end
