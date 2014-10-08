require 'spec_helper'

module Smithy
  describe PageList, :type => :model do
    include_context "a tree of pages" # see spec/support/shared_contexts/tree.rb
    include_context "acts like a content block" # see spec/support/shared_contexts

    let(:page_list) { create(:page_list, :parent => page1) }
    subject { page_list }

    it { is_expected.to validate_presence_of :parent_id }

    describe "#pages" do
      subject { page_list.pages }

      describe '#size' do
        subject { super().size }
        it { is_expected.to eql 3 }
      end

      context "with a limited count" do
        let(:page_list) { create(:page_list, :count => 2, :parent => page1) }

        describe '#size' do
          subject { super().size }
          it { is_expected.to eql 2 }
        end
      end

      context "#sort" do
        let(:page_list) { build(:page_list, :parent => page1) }
        let(:children) { page1.children }
        let(:pages) { page_list.pages }
        subject { pages }
        before do
          allow(page1).to receive(:children).and_return(children)
          allow(children).to receive(:all).and_return(children)
          allow(children).to receive(:except).with(:order).and_return(children)
        end
        it "shouldn't get ordered" do
          expect(children).to_not receive(:order)
          page_list.pages
        end

        context "by sitemap" do
          before { page_list.sort = "sitemap" }
          it "shouldn't get ordered" do
            expect(children).to_not receive(:except)
            expect(children).to_not receive(:order)
            page_list.pages
          end
        end
        context "when set to" do
          before do
            expect(children).to receive(:except).with(:order)
          end
          it "'title_asc', orders pages by 'title ASC'" do
            page_list.sort = "title_asc"
            expect(children).to receive(:order).with('title ASC')
            page_list.pages
          end
          it "'title_desc', orders pages by 'title DESC'" do
            page_list.sort = "title_desc"
            expect(children).to receive(:order).with('title DESC')
            page_list.pages
          end
          it "'created_asc', orders pages by 'created ASC'" do
            page_list.sort = "created_asc"
            expect(children).to receive(:order).with('created_at ASC')
            page_list.pages
          end
          it "'created_desc', orders pages by 'created DESC'" do
            page_list.sort = "created_desc"
            expect(children).to receive(:order).with('created_at DESC')
            page_list.pages
          end
        end
      end

      context "with a specific #page_template_id" do
        subject { create(:page_list, :parent => page1, :page_template_id => page1_1.template_id, :sort => "created_desc").pages }
        specify { expect(subject.map(&:title)).to eql ['Page 1-1'] }
      end
    end

  end
end
