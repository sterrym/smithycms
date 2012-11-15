require 'spec_helper'

describe Smithy::Liquid::Tags::Html do
  it 'renders the stylesheet link tag' do
    html = render_tag('stylesheet_link_tag', 'application')
    html.should eql '<link href="/assets/application.css" media="screen" rel="stylesheet" type="text/css" />'
  end

  it 'renders the javascript include tag' do
    html = render_tag('javascript_include_tag', 'foo')
    html.should eql '<script src="/assets/foo.js" type="text/javascript"></script>'
  end

  def render_tag(tag_name, param)
    controller = ApplicationController.new
    registers       = { :controller => controller }
    liquid_context  = ::Liquid::Context.new({}, {}, registers)
    ::Liquid::Template.parse("{% #{tag_name} #{param} %}").render(liquid_context)
  end
end

