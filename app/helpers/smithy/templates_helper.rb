module Smithy
  module TemplatesHelper
    include Smithy::Liquid::Rendering

    def render_smithy_nav(options="")
      context = ::Liquid::Context.new({}, smithy_default_assigns, smithy_default_registers, false)
      ::Liquid::Template.parse("{% nav #{options} %}").render(liquid_context)
    end

    def render_smithy_partial(partial_name)
      partial_template = Smithy::Template.partials.find_by_name(partial_name)
      return if partial_template.blank?
      partial_template.liquid_template.render(liquid_context)
    end
  end
end
