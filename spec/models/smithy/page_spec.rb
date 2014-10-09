require 'rails_helper'

RSpec.describe Smithy::Page, :type => :model do
  let(:page) { build(:page) }
  subject { page }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :template }

  it { is_expected.to accept_nested_attributes_for(:contents).allow_destroy(true) }

  it { is_expected.to belong_to :parent }
  it { is_expected.to belong_to :template }
  it { is_expected.to have_many :children }
  it { is_expected.to have_many(:containers).through(:template) }
  it { is_expected.to have_many :contents }

  it { is_expected.to be_valid }

  # defaults

  describe '#show_in_navigation' do
    subject { super().show_in_navigation }
    it { is_expected.to be_truthy }
  end

  describe '#cache_length' do
    subject { super().cache_length }
    it { is_expected.to eql 600 }
  end

  describe '#site' do
    subject { super().site }
    it { is_expected.to be_a Smithy::Site }
  end

  context "won't allow a second root page" do
    let!(:first_home_page) { create(:page, :title => "Home1") }
    subject { build(:page, :title => "Home") }
    before { subject.save; }
    it { is_expected.not_to be_persisted }
    it { expect(subject.errors[:parent_id]).to eq(['must have a parent']) }
    it "can still update itself" do
      expect(first_home_page.update_attributes(:published_at => Time.now)).to be_truthy
    end
  end

  context "publishing" do
    subject { create(:page, :title => "Home", :published_at => nil) }

    describe '#published_at' do
      subject { super().published_at }
      it { is_expected.to be_nil }
    end
    context "with publish attribute" do
      context "and published_at unset" do
        subject { create(:page, :title => "Home", :published_at => nil, :publish => true) }

        describe '#published_at' do
          subject { super().published_at }
          it { is_expected.not_to be_nil }
        end
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
        it { is_expected.to be_falsey }
      end

      describe "#containers" do
        subject { page.containers }
        it { is_expected.to be_an(ActiveRecord::Associations::CollectionProxy) }
        it { is_expected.to be_empty }
      end

      describe "#render_container" do
        subject { page.render_container("foo_bar") }
        it { is_expected.to be_empty }
        it { is_expected.to eq("") }
      end
    end

    context "using a template with 1 container" do
      let(:template) { create(:template, :content => one_container, :template_type => "template") }
      let(:page) { create(:page, :title => "Foo", :template => template) }
      describe "#container?" do
        specify { expect(page.container?("foo")).to be_truthy }
        specify { expect(page.container?("bar")).to be_falsey }
      end

      describe "#containers" do
        subject { page.containers }
        it 'has 1 item' do
          expect(subject.size).to eq(1)
        end
      end

      describe "#render_container" do
        subject { page.render_container(:foo) }
        it { is_expected.to be_a String }
        it { is_expected.to be_empty }
      end
    end
  end

  describe "#to_liquid" do
    subject { create(:page, :title => "Foo Bar").to_liquid }
    it { is_expected.to be_a(Smithy::Liquid::Drops::Page) }
  end

  describe "#permalink and #path auto-generation" do
    include_context "a tree of pages"
    subject { home }

    describe '#permalink' do
      subject { super().permalink }
      it { is_expected.not_to be_blank }
    end
    context "when it's the root page" do
      subject { home }

      describe '#path' do
        subject { super().path }
        it { is_expected.to eq('/') }
      end

      describe '#permalink' do
        subject { super().permalink }
        it { is_expected.to eq("home") }
      end
    end
    context "when it's a child of the root page" do
      subject { page1 }

      describe '#path' do
        subject { super().path }
        it { is_expected.to eq('/page-1') }
      end

      describe '#permalink' do
        subject { super().permalink }
        it { is_expected.to eq('page-1') }
      end
      context "with a specified permalink" do
        before do
          page1.update_attributes(:permalink => "baz")
        end
        subject { page1 }

        describe '#permalink' do
          subject { super().permalink }
          it { is_expected.to eq('baz') }
        end

        describe '#path' do
          subject { super().path }
          it { is_expected.to eq('/baz') }
        end
      end
    end
    context "when it's a subpage" do
      subject { page1_1 }

      describe '#path' do
        subject { super().path }
        it { is_expected.to eq('/page-1/page-1-1') }
      end

      describe '#permalink' do
        subject { super().permalink }
        it { is_expected.to eq('page-1-1') }
      end
    end
    context "within the same scope as another page" do
      subject { create(:page, :title => "Page 1", :parent => home) }

      describe '#path' do
        subject { super().path }
        it { is_expected.to match(/^\/page-1-/) }
      end

      describe '#permalink' do
        subject { super().permalink }
        it { is_expected.to match(/^page-1-/) }
      end
    end
    %w(index new edit session login logout users smithy).each do |word|
      context "using a reserved word for the title (#{word})" do
        subject { build(:page, :title => word, :parent => home) }
        before { subject.valid? }
        specify { expect(subject.errors[:title]).not_to be_blank }
      end
    end
  end
end
