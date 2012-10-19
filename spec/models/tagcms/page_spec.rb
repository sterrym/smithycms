require 'spec_helper'

describe Tagcms::Page do
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
  it { should validate_presence_of :permalink }
  it { should validate_presence_of :template_id }

  it { should belong_to :parent }
  it { should belong_to :template }
  it { should have_many :children }
  it { should have_many(:containers).through(:template) }
  it { should have_many :contents }

  context "won't allow a second root page" do
    let!(:first_home_page) { FactoryGirl.create(:page, :title => "Home1") }
    subject { FactoryGirl.build(:page, :title => "Home", :permalink => nil) }
    it { subject.save; should_not be_persisted }
    it { subject.save; subject.errors[:parent_id].should == ['must have a parent'] }
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

  describe "#permalink and #path auto-generation" do
    subject { FactoryGirl.create(:page, :title => "Foo Bar", :permalink => nil) }
    its(:permalink) { should_not be_blank }
    context "when it's the root page" do
      subject { FactoryGirl.create(:page, :title => "Home", :permalink => nil) }
      its(:permalink) { should == "home" }
      its(:path) { should == nil }
    end
    context "when it's a child of the root page" do
      let(:home) { FactoryGirl.create(:page, :title => "Home", :permalink => nil) }
      subject { FactoryGirl.create(:page, :title => "Foo Bar", :parent => home) }
      its(:permalink) { should == 'foo-bar' }
      its(:path) { should == '/foo-bar' }
    end
    context "when it's a subpage" do
      let(:home) { FactoryGirl.create(:page, :title => "Home", :permalink => nil) }
      let(:subpage) { FactoryGirl.create(:page, :title => "Foo Bar", :parent => home, :permalink => nil) }
      subject { FactoryGirl.create(:page, :title => "Baz Qux", :parent => subpage) }
      its(:permalink) { should == 'baz-qux' }
      its(:path) { should == '/foo-bar/baz-qux' }
    end
    context "within the same scope as another page" do
      let!(:home) { FactoryGirl.create(:page, :title => "Home", :permalink => nil) }
      let!(:subpage) { FactoryGirl.create(:page, :title => "Foo Bar", :permalink => nil, :parent => home) }
      subject { FactoryGirl.create(:page, :title => "Foo Bar", :parent => home) }
      its(:permalink) { should == 'foo-bar--2' }
      its(:path) { should == '/foo-bar--2' }
    end
    context "using a reserved word for the title" do
      subject { FactoryGirl.build(:page, :title => "new") }
      it "will have an error on :title" do
        subject.valid?
        subject.errors[:title].should_not be_blank
      end
    end
  end
end
