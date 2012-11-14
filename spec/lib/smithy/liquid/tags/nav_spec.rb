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
    registers = { :site => site, :page => home }.merge(registers)
    liquid_context = ::Liquid::Context.new({}, {}, registers)
    # output = Liquid::Template.parse("{% nav #{source} #{template_option} %}").render(liquid_context)
    # output.gsub(/\n\s{0,}/, '')
    ::Liquid::Template.parse("{% nav #{root} #{tag_options} %}").render(liquid_context).gsub(/\n|\s\s/, '')
  end

  let(:navigation_for_depth_of_1) {
    %Q{<ul id="nav">
        <li id="nav-page-1"><a href="/page-1">Page 1</a></li>
        <li id="nav-page-2"><a href="/page-2">Page 2</a></li>
      </ul>}.gsub(/\n|\s\s/, '')
  }
  let(:navigation_for_depth_of_2) {
    %Q{<ul id="nav">
        <li id="nav-page-1"><a href="/page-1">Page 1</a>
          <ul>
            <li id="nav-page-1-1"><a href="/page-1/page-1-1">Page 1-1</a></li>
            <li id="nav-page-1-2"><a href="/page-1/page-1-2">Page 1-2</a></li>
            <li id="nav-page-1-3"><a href="/page-1/page-1-3">Page 1-3</a></li>
          </ul>
        </li>
        <li id="nav-page-2"><a href="/page-2">Page 2</a></li>
      </ul>}.gsub(/\n|\s\s/, '')
  }
  let(:navigation_for_depth_of_0) {
    %Q{<ul id="nav">
        <li id="nav-page-1"><a href="/page-1">Page 1</a><ul>
            <li id="nav-page-1-1"><a href="/page-1/page-1-1">Page 1-1</a></li>
            <li id="nav-page-1-2"><a href="/page-1/page-1-2">Page 1-2</a></li>
            <li id="nav-page-1-3"><a href="/page-1/page-1-3">Page 1-3</a>
              <ul>
                <li id="nav-page-1-3-1"><a href="/page-1/page-1-3/page-1-3-1">Page 1-3-1</a></li>
              </ul>
            </li>
          </ul>
        </li>
        <li id="nav-page-2"><a href="/page-2">Page 2</a></li>
      </ul>}.gsub(/\n|\s\s/, '')
  }
end
