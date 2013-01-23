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

  # defaults
  its(:show_in_navigation) { should be_true }
  its(:cache_length) { should eql 600 }

  context "won't allow a second root page" do
    let!(:first_home_page) { FactoryGirl.create(:page, :title => "Home1") }
    subject { FactoryGirl.build(:page, :title => "Home") }
    before { subject.save; }
    it { should_not be_persisted }
    it { subject.errors[:parent_id].should == ['must have a parent'] }
    it "can still update itself" do
      first_home_page.update_attributes(:published_at => Time.now).should be_true
    end
  end

  context "publishing" do
    subject { FactoryGirl.create(:page, :title => "Home", :published_at => nil) }
    its(:published_at) { should be_nil }
    context "with publish attribute" do
      context "and published_at unset" do
        subject { FactoryGirl.create(:page, :title => "Home", :published_at => nil, :publish => true) }
        its(:published_at) { should_not be_nil }
      end
      context "and published_at set" do
        subject { FactoryGirl.create(:page, :title => "Home", :published_at => Time.now) }
        it "should set published_at to nil if publish is false" do
          expect{ subject.update_attributes(:publish => false) }.to change{subject.published_at}
        end
        it "shouldn't change published_at to nil if publish is nil" do
          expect{ subject.update_attributes(:publish => nil) }.to_not change{subject.published_at}
        end
      end
    end
  end

  describe  "#generated_browser_title" do
    subject { FactoryGirl.create(:page, :title => "Foo Bar").generated_browser_title }
    it { should == 'Foo Bar' }
    context "when it's a child page" do
      let(:home) { FactoryGirl.create(:page, :title => "Home") }
      let(:subpage) { FactoryGirl.create(:page, :title => "Foo Bar", :parent => home) }
      subject { FactoryGirl.create(:page, :title => "Baz Qux", :parent => subpage).generated_browser_title }
      it { should == 'Foo Bar | Baz Qux'}
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
    context "with a pre-built tree" do
      include_context "a tree of pages"
      it { should be_an(Array) }
      its(:size) { should == 11 }
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

  describe "#permalink and #path auto-generation" do
    include_context "a tree of pages"
    subject { home }
    its(:permalink) { should_not be_blank }
    context "when it's the root page" do
      subject { home }
      its(:path) { should == '/' }
      its(:permalink) { should == "home" }
    end
    context "when it's a child of the root page" do
      subject { page1 }
      its(:path) { should == '/page-1' }
      its(:permalink) { should == 'page-1' }
      context "with a specified permalink" do
        before do
          page1.update_attributes(:permalink => "baz")
        end
        subject { page1 }
        its(:permalink) { should == 'baz' }
        its(:path) { should == '/baz' }
      end
    end
    context "when it's a subpage" do
      subject { page1_1 }
      its(:path) { should == '/page-1/page-1-1' }
      its(:permalink) { should == 'page-1-1' }
    end
    context "within the same scope as another page" do
      subject { FactoryGirl.create(:page, :title => "Page 1", :parent => home) }
      its(:path) { should == '/page-1--2' }
      its(:permalink) { should == 'page-1--2' }
    end
    %w(index new edit session login logout users smithy).each do |word|
      context "using a reserved word for the title (#{word})" do
        subject { FactoryGirl.build(:page, :title => word, :parent => home) }
        before { subject.valid? }
        specify { subject.errors[:title].should_not be_blank }
      end
    end
  end
end
