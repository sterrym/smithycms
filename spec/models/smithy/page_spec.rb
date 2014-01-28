require 'spec_helper'

describe Smithy::Page do
  let(:page) { build(:page) }
  subject { page }

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

  its(:site) { should be_a Smithy::Site }

  context "won't allow a second root page" do
    let!(:first_home_page) { create(:page, :title => "Home1") }
    subject { build(:page, :title => "Home") }
    before { subject.save; }
    it { should_not be_persisted }
    it { subject.errors[:parent_id].should == ['must have a parent'] }
    it "can still update itself" do
      first_home_page.update_attributes(:published_at => Time.now).should be_true
    end
  end

  context "publishing" do
    subject { create(:page, :title => "Home", :published_at => nil) }
    its(:published_at) { should be_nil }
    context "with publish attribute" do
      context "and published_at unset" do
        subject { create(:page, :title => "Home", :published_at => nil, :publish => true) }
        its(:published_at) { should_not be_nil }
      end
      context "and published_at set" do
        subject { create(:page, :title => "Home", :published_at => Time.now) }
        it "should set published_at to nil if publish is false" do
          expect{ subject.update_attributes(:publish => false) }.to change{subject.published_at}
        end
        it "shouldn't change published_at to nil if publish is nil" do
          expect{ subject.update_attributes(:publish => nil) }.to_not change{subject.published_at}
        end
      end
    end
  end

  context "page containers" do
    let(:one_container) { File.read(Smithy::Engine.root.join('spec', 'fixtures', 'templates', 'foo.html.liquid')) }
    let(:three_containers) { File.read(Smithy::Engine.root.join('spec', 'fixtures', 'templates', 'foo_bar_baz.html.liquid')) }

    context "using a template without containers" do
      let(:page) { create(:page, :title => "Foo") }
      describe "#container?" do
        subject{ page.container?("foo") }
        it { should be_false }
      end

      describe "#containers" do
        subject { page.containers }
        it { should be_an(Array) }
        it { should be_empty }
      end

      describe "#render_container" do
        subject { page.render_container("foo_bar") }
        it { should be_empty }
        it { should == "" }
      end
    end

    context "using a template with 1 container" do
      let(:template) { create(:template, :content => one_container, :template_type => "template") }
      let(:page) { create(:page, :title => "Foo", :template => template) }
      describe "#container?" do
        specify { page.container?("foo").should be_true }
        specify { page.container?("bar").should be_false }
      end

      describe "#containers" do
        subject { page.containers }
        it { should have(1).item }
      end

      describe "#render_container" do
        subject { page.render_container(:foo) }
        it { should be_a String }
        it { should be_empty }
      end
    end
  end

  describe "#to_liquid" do
    subject { create(:page, :title => "Foo Bar").to_liquid }
    it { should be_a(Smithy::Liquid::Drops::Page) }
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
      subject { create(:page, :title => "Page 1", :parent => home) }
      its(:path) { should == '/page-1--2' }
      its(:permalink) { should == 'page-1--2' }
    end
    %w(index new edit session login logout users smithy).each do |word|
      context "using a reserved word for the title (#{word})" do
        subject { build(:page, :title => word, :parent => home) }
        before { subject.valid? }
        specify { subject.errors[:title].should_not be_blank }
      end
    end
  end
end
