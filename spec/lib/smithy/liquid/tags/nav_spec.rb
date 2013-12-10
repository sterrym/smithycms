require 'spec_helper'

describe Smithy::Liquid::Tags::Nav do
  include_context "a tree of pages" # see spec/support/shared_contexts/tree.rb
  let(:site) { Smithy::Site.new }
  subject { render_nav 'site' }

  it { should eql navigation_for_depth_of_1 }

  context "a depth of 2" do
    subject { render_nav 'site', 'depth: 2' }
    it { should eql navigation_for_depth_of_2 }
  end

  context "a depth of 0" do
    subject { render_nav 'site', 'depth: 0' }
    it { should eql navigation_for_depth_of_0 }
  end

  context "a custom id" do
    subject { render_nav 'site', 'id: foo' }
    it { should start_with '<ul id="foo"' }
    it { should include '<li id="foo-page-1'}
  end

  context "with a selected page" do
    subject { render_nav 'site', 'active_class: foo', { :page => page1 } }
    let(:navigation) { navigation_for_depth_of_1.sub(/id="nav-page-1"/, 'id="nav-page-1" class="foo"')}
    it { should eql navigation }
  end

  context "with a selected page and a custom class" do
    subject { render_nav 'site', '', { :page => page1 } }
    let(:navigation) { navigation_for_depth_of_1.sub(/id="nav-page-1"/, 'id="nav-page-1" class="on"')}
    it { should eql navigation }
  end

  def render_nav(root = 'site', tag_options = '', registers = {})
    controller = double(ApplicationController)
    controller.stub_chain(:request, :path).and_return('/')
    registers = { :site => site, :page => home, :controller => controller }.merge(registers)
    liquid_context = ::Liquid::Context.new({}, {}, registers)
    ::Liquid::Template.parse("{% nav #{root} #{tag_options} %}").render(liquid_context).gsub(/\n|\s\s/, '')
  end

  let(:navigation_for_depth_of_0) { File.read(Smithy::Engine.root.join('spec', 'fixtures', 'nav', 'navigation_for_depth_of_0.html')).gsub(/\n|\s\s/, '') }
  let(:navigation_for_depth_of_1) { File.read(Smithy::Engine.root.join('spec', 'fixtures', 'nav', 'navigation_for_depth_of_1.html')).gsub(/\n|\s\s/, '') }
  let(:navigation_for_depth_of_2) { File.read(Smithy::Engine.root.join('spec', 'fixtures', 'nav', 'navigation_for_depth_of_2.html')).gsub(/\n|\s\s/, '') }
end
