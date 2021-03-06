require 'rails_helper'

RSpec.describe Smithy::Liquid::Tags::Csrf do
  it 'renders the param tag for form' do
    html = render_tag
    expect(html).to eq('<input type="hidden" name="token" value="42">')
  end

  it 'renders the meta tag used by ajax requests' do
    html = render_tag('csrf_meta_tag')
    expect(html).to include '<meta name="csrf-param" content="token">'
    expect(html).to include '<meta name="csrf-token" content="42">'
  end

  it 'renders the meta tag used by ajax requests' do
    html = render_tag('csrf_meta_tags')
    expect(html).to include '<meta name="csrf-param" content="token">'
    expect(html).to include '<meta name="csrf-token" content="42">'
  end

  def render_tag(tag_name = 'csrf_param')
    controller = double('controller', {
      :request_forgery_protection_token => 'token',
      :form_authenticity_token          => '42'
    })
    registers       = { :controller => controller }
    liquid_context  = ::Liquid::Context.new({}, {}, registers)
    ::Liquid::Template.parse("{% #{tag_name} %}").render(liquid_context)
  end

end
