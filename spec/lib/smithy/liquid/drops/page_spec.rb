require 'rails_helper'

RSpec.describe Smithy::Liquid::Drops::Page do
  include_context "a tree of pages" # see spec/support/shared_contexts/tree.rb

  describe "#breadcrumbs" do
    subject { render_template("{{ subpage.breadcrumbs | map: 'title' | join: ', ' }}", { 'subpage' => page1_3_1 }) }
    it { is_expected.to eql "Page 1, Page 1-3" }
  end

  describe "#browser_title" do
    subject { render_template("{{ home.browser_title }}") }
    it { is_expected.to eql "Home" }
  end

  describe "#children" do
    subject { render_template("{{ home.children | map: 'title' | join: ', ' }}") }
    it { is_expected.to eql "Page 1, Page 2, Page 3, Page 4" }
    context "subpages" do
      subject { render_template("{{ home.children.first.children | map: 'title' | join: ', ' }}") }
      it { is_expected.to eql "Page 1-1, Page 1-2, Page 1-3" }
    end
  end

  describe "#container" do
    before do
      page1.template.update_attribute(:content, File.read(Smithy::Engine.root.join('spec', 'fixtures', 'templates', 'foo.html.liquid')))
    end
    subject { page1.to_liquid['container'] }
    it { is_expected.to be_a Hash }
    it { is_expected.to include('foo') }

    describe '#keys' do
      subject { super().keys }
      it { is_expected.to eq(page1.containers.map(&:name)) }
    end
  end

  describe "#browser_title" do
    let(:subpage) { create(:page, :title => "Foo Bar", :parent => home) }
    subject { home.to_liquid['browser_title'] }
    context "a generated browser_title" do
      it { is_expected.to eq('Home') }
      context "when it's a child page" do
        subject { create(:page, :title => "Baz Qux", :parent => subpage).to_liquid['browser_title'] }
        it { is_expected.to eq('Baz Qux | Foo Bar')}
      end
      context "with a site title" do
        before do
          Smithy::Site.title = 'CoolSite'
        end
        subject { home.to_liquid['browser_title']}
        it { is_expected.to eq('Home | CoolSite') }
        after do
          Smithy::Site.title = nil
        end
      end
    end
    context "with a custom set browser_title" do
      before do
        Smithy::Site.title = 'CoolSite'
        home.update_attribute(:browser_title, "This is custom!")
      end
      it { is_expected.to eq('This is custom!') }
      after do
        Smithy::Site.title = nil
      end
    end
  end

  describe "#meta_description" do
    subject { render_template("{{ home.meta_description }}") }
    it { is_expected.to eql home.description}
  end

  describe "#meta_keywords" do
    subject { render_template("{{ home.meta_keywords }}") }
    it { is_expected.to eql home.keywords}
  end

  describe "#parent" do
    subject { render_template("{{ subpage.parent.title }}", { 'subpage' => page1 }) }
    it { is_expected.to eql "Home"}
  end

  describe "#path" do
    subject { render_template("{{ subpage.path }}", { 'subpage' => page1_1 }) }
    it { is_expected.to eql "/page-1/page-1-1"}
  end

  describe "#published? when" do
    context "true" do
      subject { render_template("{{ home.published? }}") }
      it { is_expected.to eql 'true' }
    end
    context "false" do
      subject { render_template("{{ subpage.published? }}", { 'subpage' => page3 }) }
      it { is_expected.to eql 'false' }
    end
  end

  describe "#show_in_navigation?" do
    context "true" do
      subject { render_template("{{ home.show_in_navigation? }}") }
      it { is_expected.to eql 'true' }
    end
    context "false" do
      subject { render_template("{{ subpage.show_in_navigation? }}", { 'subpage' => page3 }) }
      it { is_expected.to eql 'false' }
    end
  end

  def render_template(template = '', assigns = {})
    assigns = { 'home' => home }.merge(assigns)
    Liquid::Template.parse(template).render(assigns)
  end
end
