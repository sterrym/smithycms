require 'rails_helper'

RSpec.describe Smithy::PagesHelper, :type => :helper do
  describe "#tree_for_select" do
    subject { helper.tree_for_select }
    context "when empty" do
      it { is_expected.to be_an(Array) }
      it 'has no items' do
        expect(subject.size).to eq(0)
      end
    end
    context "with a pre-built tree" do
      include_context "a tree of pages"
      before do
        assign(:page, home)
      end
      it { is_expected.to be_an(Array) }
      it 'has 11 items' do
        expect(subject.size).to eq(11)
      end
      specify { expect(subject[0]).to eq(['Home', home.id]) }
      specify { expect(subject[1]).to eq(['- Page 1', page1.id]) }
      specify { expect(subject[2]).to eq(['-- Page 1-1', page1_1.id]) }
      specify { expect(subject[3]).to eq(['-- Page 1-2', page1_2.id]) }
      specify { expect(subject[4]).to eq(['-- Page 1-3', page1_3.id]) }
      specify { expect(subject[5]).to eq(['--- Page 1-3-1', page1_3_1.id]) }
      specify { expect(subject[6]).to eq(['- Page 2', page2.id]) }
      specify { expect(subject[7]).to eq(['-- Page 2-1', page2_1.id]) }
      specify { expect(subject[8]).to eq(['-- Page 2-2', page2_2.id]) }
      specify { expect(subject[9]).to eq(['- Page 3', page3.id]) }
      specify { expect(subject[10]).to eq(['- Page 4', page4.id]) }
    end
  end
end
