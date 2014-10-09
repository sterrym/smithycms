require 'rails_helper'

RSpec.describe Smithy::Liquid::Filters::AssetTag do
  context "with an existing image" do
    subject(:image_tag) { render_filter('/assets/smithy/logo.png', 'alt:Foo Bar') }
    it { is_expected.to eql '<img alt="Foo Bar" src="/assets/smithy/logo.png" />' }
  end

  def render_filter(asset_path, options)
    controller = ApplicationController.new
    registers       = { :controller => controller }
    liquid_context  = ::Liquid::Context.new({}, {}, registers)
    ::Liquid::Template.parse("{{ '#{asset_path}' | image_tag: '#{options}' }}").render(liquid_context)
  end
end
