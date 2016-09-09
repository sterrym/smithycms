require 'rails_helper'
require 'smithy/content'
RSpec.describe Smithy::Content, :type => :model do
  include_context "acts like a content block" # see spec/support/shared_contexts
  context "#markdown_content" do
    subject { create(:content).markdown_content }
    it { is_expected.not_to be_blank }
  end
end
