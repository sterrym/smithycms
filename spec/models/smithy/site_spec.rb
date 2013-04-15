require 'spec_helper'

describe Smithy::Site do
  include_context "a tree of pages" # see spec/support/shared_contexts/tree.rb

  subject { Smithy::Site.new }

  its(:root) { should eql home }
  its(:title) { should be_nil }

  context "with a title" do
    before do
      Smithy::Site.title = 'FooBar'
    end
    its(:title) { should eql 'FooBar' }
  end

  describe "#to_liquid" do
    specify "calls to_liquid on the root" do
      subject.root.should_receive(:to_liquid)
      subject.to_liquid
    end
  end
end
