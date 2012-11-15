module Smithy
  module Liquid
    module Tags
      module Csrf

        class Param < ::Liquid::Tag
          def render(context)
            controller  = context.registers[:controller]
            name        = controller.send(:request_forgery_protection_token).to_s
            value       = controller.send(:form_authenticity_token)
            %(<input type="hidden" name="#{name}" value="#{value}">)
          end
        end

        class Meta < ::Liquid::Tag
          def render(context)
            controller  = context.registers[:controller]
            name        = controller.send(:request_forgery_protection_token).to_s
            value       = controller.send(:form_authenticity_token)
            %{<meta name="csrf-param" content="#{name}">\n} +
            %{<meta name="csrf-token" content="#{value}">}
          end
        end
      end
      ::Liquid::Template.register_tag('csrf_param', Csrf::Param)
      ::Liquid::Template.register_tag('csrf_meta_tag', Csrf::Meta)
      ::Liquid::Template.register_tag('csrf_meta_tags', Csrf::Meta)
    end
  end
end
