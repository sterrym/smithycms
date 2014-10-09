require 'rails_helper'

RSpec.describe Smithy::Liquid::Tags::Html do
  it 'renders the stylesheet link tag' do
    html = render_tag('stylesheet_link_tag', 'application')
    expect(html).to eql '<link href="/assets/application.css" media="screen" rel="stylesheet" />'
  end

  it 'renders the javascript include tag' do
    html = render_tag('javascript_include_tag', 'application')
    expect(html).to eql '<script src="/assets/application.js"></script>'
  end

  it 'renders the smithy javascript include tag' do
    html = render_tag('smithy_javascript_include_tag', 'application')
    expect(html).to eql '<script src="/templates/javascripts/application.js"></script>'
  end

  it 'doesn\'t add ".js" if it\'s already there' do
    html = render_tag('smithy_javascript_include_tag', 'application.js')
    expect(html).to eql '<script src="/templates/javascripts/application.js"></script>'
  end

  it 'renders the smithy stylesheet link tag' do
    html = render_tag('smithy_stylesheet_link_tag', 'application')
    expect(html).to eql '<link href="/templates/stylesheets/application.css" media="screen" rel="stylesheet" />'
  end

  it 'doesn\'t add ".css" if it\'s already there' do
    html = render_tag('smithy_stylesheet_link_tag', 'application.css')
    expect(html).to eql '<link href="/templates/stylesheets/application.css" media="screen" rel="stylesheet" />'
  end

  def render_tag(tag_name, param)
    controller = ApplicationController.new
    registers       = { :controller => controller }
    liquid_context  = ::Liquid::Context.new({}, {}, registers)
    ::Liquid::Template.parse("{% #{tag_name} #{param} %}").render(liquid_context)
  end
end

