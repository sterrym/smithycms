require 'spec_helper'

describe Smithy::Page do
  subject { FactoryGirl.build(:page) }

  it { should allow_mass_assignment_of :browser_title }
  it { should allow_mass_assignment_of :cache_length }
  it { should allow_mass_assignment_of :description }
  it { should allow_mass_assignment_of :keywords }
  it { should allow_mass_assignment_of :permalink }
  it { should allow_mass_assignment_of :published_at }
  it { should allow_mass_assignment_of :show_in_navigation }
  it { should allow_mass_assignment_of :title }
  it { should_not allow_mass_assignment_of :lft }
  it { should_not allow_mass_assignment_of :rgt }
  it { should_not allow_mass_assignment_of :depth }

  it { should validate_presence_of :title }
  it { should validate_presence_of :template }

  it { should accept_nested_attributes_for(:contents).allow_destroy(true) }

  it { should belong_to :parent }
  it { should belong_to :template }
  it { should have_many :children }
  it { should have_many(:containers).through(:template) }
  it { should have_many :contents }

  it { should be_valid }

  context "won't allow a second root page" do
    let!(:first_home_page) { FactoryGirl.create(:page, :title => "Home1") }
    subject { FactoryGirl.build(:page, :title => "Home") }
    before { subject.save; }
    it { should_not be_persisted }
    it { subject.errors[:parent_id].should == ['must have a parent'] }
  end

  describe  "#generated_browser_title" do
    subject { FactoryGirl.create(:page, :title => "Foo Bar").generated_browser_title }
    it { should == 'Foo Bar' }
    context "when it's a child page" do
      let(:home) { FactoryGirl.create(:page, :title => "Home") }
      let(:subpage) { FactoryGirl.create(:page, :title => "Foo Bar", :parent => home) }
      subject { FactoryGirl.create(:page, :title => "Baz Qux", :parent => subpage).generated_browser_title }
      it { should == 'Home | Foo Bar | Baz Qux'}
    end
  end

  describe "#container_names" do
    subject { FactoryGirl.create(:page, :title => "Foo Bar").container_names }
    it { should be_an(Array) }
    # TODO: describe container names that come from a template
  end

  describe "#containers" do
    # TODO: describe containers that come from a template
  end

  describe "#to_liquid" do
    subject { FactoryGirl.create(:page, :title => "Foo Bar").to_liquid }
    it { should be_a(Hash) }
    it { should have_key('title') }
    it { should have_key('browser_title') }
    it { should have_key('meta_description') }
    it { should have_key('meta_keywords') }
    it { should have_key('container') }
    describe "['container']" do
      let(:page){ FactoryGirl.create(:page, :title => "Foo Bar") }
      subject { page.to_liquid['container'] }
      its(:keys) { should == page.containers.map(&:name) }
    end
  end

  describe ".tree_for_select" do
    subject { Smithy::Page.tree_for_select }
    context "when empty" do
      it { should be_an(Array) }
      its(:size) { should == 0 }
    end
    context "with some pages" do
      let!(:home) { FactoryGirl.create(:page, :title => "Home") }
      let!(:page1) { FactoryGirl.create(:page, :title => "Page1", :parent => home) }
      let!(:page2) { FactoryGirl.create(:page, :title => "Page2", :parent => home) }
      let!(:page1_1) { FactoryGirl.create(:page, :title => "Page1-1", :parent => page1) }
      let!(:page1_2) { FactoryGirl.create(:page, :title => "Page1-2", :parent => page1) }
      it { should be_an(Array) }
      its(:size) { should == 5 }
      specify { subject[0].should == ['Home', home.id] }
      specify { subject[1].should == ['- Page1', page1.id] }
      specify { subject[2].should == ['-- Page1-1', page1_1.id] }
      specify { subject[3].should == ['-- Page1-2', page1_2.id] }
      specify { subject[4].should == ['- Page2', page2.id] }
    end
  end

  describe "#permalink and #path auto-generation" do
    subject { FactoryGirl.create(:page, :title => "Foo Bar") }
    its(:permalink) { should_not be_blank }
    context "when it's the root page" do
      subject { FactoryGirl.create(:page, :title => "Home") }
      its(:path) { should == '/' }
      its(:permalink) { should == "home" }
    end
    context "when it's a child of the root page" do
      let(:home) { FactoryGirl.create(:page, :title => "Home") }
      subject { FactoryGirl.create(:page, :title => "Foo Bar", :parent => home) }
      its(:path) { should == '/foo-bar' }
      its(:permalink) { should == 'foo-bar' }
      context "with a specified permalink" do
        subject { FactoryGirl.create(:page, :permalink => 'baz', :title => "Foo Bar", :parent => home) }
        its(:permalink) { should == 'baz' }
        its(:path) { should == '/baz' }
      end
    end
    context "when it's a subpage" do
      let(:home) { FactoryGirl.create(:page, :title => "Home") }
      let(:subpage) { FactoryGirl.create(:page, :title => "Foo Bar", :parent => home) }
      subject { FactoryGirl.create(:page, :title => "Baz Qux", :parent => subpage) }
      its(:path) { should == '/foo-bar/baz-qux' }
      its(:permalink) { should == 'baz-qux' }
    end
    context "within the same scope as another page" do
      let!(:home) { FactoryGirl.create(:page, :title => "Home") }
      let!(:subpage) { FactoryGirl.create(:page, :title => "Foo Bar", :parent => home) }
      subject { FactoryGirl.create(:page, :title => "Foo Bar", :parent => home) }
      its(:path) { should == '/foo-bar--2' }
      its(:permalink) { should == 'foo-bar--2' }
    end
    %w(index new edit session login logout users smithy).each do |word|
      context "using a reserved word for the title (#{word})" do
        let!(:home) { FactoryGirl.build(:page, :title => "home") }
        subject { FactoryGirl.build(:page, :title => word, :parent => home) }
        before { subject.valid? }
        specify { subject.errors[:title].should_not be_blank }
      end
    end
  end
end
