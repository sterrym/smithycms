require 'spec_helper'

module Smithy
  describe PageList do
    include_context "a tree of pages" # see spec/support/shared_contexts/tree.rb
    include_context "acts like a content block" # see spec/support/shared_contexts

    let(:page_list) { FactoryGirl.create(:page_list, :parent => page1) }
    subject { page_list }

    it { should allow_mass_assignment_of :count }
    it { should allow_mass_assignment_of :include_children }
    it { should allow_mass_assignment_of :page_template_id }
    it { should allow_mass_assignment_of :parent_id }
    it { should allow_mass_assignment_of :sort }

    it { should validate_presence_of :parent_id }

    describe "#pages" do
      subject { page_list.pages }

      its(:size) { should eql 3 }

      context "with a limited count" do
        let(:page_list) { FactoryGirl.create(:page_list, :count => 2, :parent => page1) }
        its(:size) { should eql 2 }
      end

      context "#sort" do
        subject { FactoryGirl.create(:page_list, :parent => page1).pages }
        specify { subject.map(&:title).should eql ['Page 1-1', 'Page 1-2', 'Page 1-3'] }
        context "by title ascending" do
          subject { FactoryGirl.create(:page_list, :parent => page1, :sort => "title_asc").pages }
          specify { subject.map(&:title).should eql ['Page 1-1', 'Page 1-2', 'Page 1-3'] }
        end
        context "by title descending" do
          subject { FactoryGirl.create(:page_list, :parent => page1, :sort => "title_desc").pages }
          specify { subject.map(&:title).should eql ['Page 1-3', 'Page 1-2', 'Page 1-1'] }
        end
        context "by created ascending" do
          subject { FactoryGirl.create(:page_list, :parent => page1, :sort => "created_asc").pages }
          specify { subject.map(&:title).should eql ['Page 1-1', 'Page 1-2', 'Page 1-3'] }
        end
        context "by created descending" do
          subject { FactoryGirl.create(:page_list, :parent => page1, :sort => "created_desc").pages }
          specify { subject.map(&:title).should eql ['Page 1-3', 'Page 1-2', 'Page 1-1'] }
        end
      end

      context "with a specific #page_template_id" do
        subject { FactoryGirl.create(:page_list, :parent => page1, :page_template_id => page1_1.template_id, :sort => "created_desc").pages }
        specify { subject.map(&:title).should eql ['Page 1-1'] }
      end
    end

  end
end
