module Smithy
  module Liquid
    module Tags
      class LinkTo < ::Liquid::Block
        SyntaxHelp = "Syntax Error in tag 'link_to' - Valid syntax: link_to [url]"
        Syntax = /(#{::Liquid::QuotedFragment})\s*([=!<>a-z_]+)?\s*(#{::Liquid::QuotedFragment})?/o

        def initialize(tag_name, markup, tokens)
          @tokens = tokens
          @url = markup.strip
          @url = :back if @url == ':back'
          super
        end

        def render(context)
          controller = context.registers[:controller]
          context.stack do
            controller.view_context.link_to(@url) do
              render_all(nodes, context)
            end
          end
        end

        private
          def nodes
            @nodelist.map{|n| n.is_a?(String) ? n.strip : n }
          end
      end
      ::Liquid::Template.register_tag('link_to', Smithy::Liquid::Tags::LinkTo)
    end
  end
end
