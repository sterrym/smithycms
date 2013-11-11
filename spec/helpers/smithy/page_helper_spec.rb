require 'spec_helper'

describe Smithy::PageHelper do
  describe "#tree_for_select" do
    subject { helper.tree_for_select }
    context "when empty" do
      it { should be_an(Array) }
      it { should have(0).items }
    end
    context "with a pre-built tree" do
      include_context "a tree of pages"
      before do
        assign(:page, home)
      end
      it { should be_an(Array) }
      it { should have(11).items }
      specify { subject[0].should == ['Home', home.id] }
      specify { subject[1].should == ['- Page 1', page1.id] }
      specify { subject[2].should == ['-- Page 1-1', page1_1.id] }
      specify { subject[3].should == ['-- Page 1-2', page1_2.id] }
      specify { subject[4].should == ['-- Page 1-3', page1_3.id] }
      specify { subject[5].should == ['--- Page 1-3-1', page1_3_1.id] }
      specify { subject[6].should == ['- Page 2', page2.id] }
      specify { subject[7].should == ['-- Page 2-1', page2_1.id] }
      specify { subject[8].should == ['-- Page 2-2', page2_2.id] }
      specify { subject[9].should == ['- Page 3', page3.id] }
      specify { subject[10].should == ['- Page 4', page4.id] }
    end
  end
end
