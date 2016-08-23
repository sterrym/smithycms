require 'rails_helper'

RSpec.describe Smithy::Liquid::Tags::Html do
  it '#stylesheet_link_tag renders the stylesheet link tag' do
    html = render_tag('stylesheet_link_tag', 'application')
    expect(html).to match /href=\"\/assets\/application-[a-z0-9]+\.css\"/
  end

  it '#javascript_include_tag renders the javascript include tag' do
    html = render_tag('javascript_include_tag', 'application')
    expect(html).to match /src=\"\/assets\/application-[a-z0-9]+\.js\"/
  end

  it '#smithy_javascript_include_tag renders the smithy javascript include tag' do
    html = render_tag('smithy_javascript_include_tag', 'application')
    expect(html).to match /src=\"\/templates\/javascripts\/application\.js\"/
  end

  it '#smithy_javascript_include_tag doesn\'t add ".js" if it\'s already there' do
    html = render_tag('smithy_javascript_include_tag', 'application.js')
    expect(html).to match /src=\"\/templates\/javascripts\/application\.js\"/
  end

  it '#smithy_stylesheet_link_tag renders the smithy stylesheet link tag' do
    html = render_tag('smithy_stylesheet_link_tag', 'application')
    expect(html).to match /href=\"\/templates\/stylesheets\/application\.css\"/
  end

  it '#smithy_stylesheet_link_tag doesn\'t add ".css" if it\'s already there' do
    html = render_tag('smithy_stylesheet_link_tag', 'application.css')
    expect(html).to match /href=\"\/templates\/stylesheets\/application\.css\"/
  end

  def render_tag(tag_name, param)
    controller = ApplicationController.new
    registers       = { :controller => controller }
    liquid_context  = ::Liquid::Context.new({}, {}, registers)
    ::Liquid::Template.parse("{% #{tag_name} #{param} %}").render(liquid_context)
  end
end

