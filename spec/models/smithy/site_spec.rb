require 'spec_helper'

describe Smithy::Site do
  include_context "a tree of pages" # see spec/support/shared_contexts/tree.rb

  subject { Smithy::Site.new }

  its(:root) { should == home }
  describe "#to_liquid" do
    specify "calls to_liquid on the root" do
      subject.root.should_receive(:to_liquid)
      subject.to_liquid
    end
  end
end
