require 'spec_helper'

describe "Page" do
  let(:template) { create(:template, :content => File.read(Smithy::Engine.root.join('spec', 'fixtures', 'templates', 'foo.html.liquid'))) }
  let(:home) { create(:page, :title => "This is a Page", :template => template) }
  let(:content_block) { Smithy::ContentBlock.find_by_name("Content") }
  let(:content_block_template) { create(:content_block_template, :content => "{{ content }}", :content_block => content_block)}
  let(:content) { create(:content, :content => "This is some sample content.") }
  let!(:page_content) { create(:page_content, :publishable, :page => home, :container => 'foo', :content_block => content, :content_block_template => content_block_template) }

  it "should render the Template" do
    visit '/'
    expect(page).to have_selector 'html'
    expect(page).to have_selector 'body'
  end

  it "should render the Content" do
    visit '/'
    expect(page).to have_content 'This is some sample content.'
  end
end
