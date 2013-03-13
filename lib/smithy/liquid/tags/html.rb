module Smithy
  module Liquid
    module Tags
      module Html
        class StylesheetLinkTag < ::Liquid::Tag
          Syntax = /(#{::Liquid::Expression}+)?/
          def initialize(tag_name, markup, tokens)
            if markup =~ Syntax
              @stylesheet = $1.gsub('\'', '')
            else
              raise ::Liquid::SyntaxError.new("Syntax Error in 'stylesheet_link_tag' - Valid syntax: stylesheet_link_tag <stylesheet>")
            end
            super
          end

          def render(context)
            controller  = context.registers[:controller]
            controller.view_context.send(:stylesheet_link_tag, @stylesheet)
          end
        end
        class JavascriptIncludeTag < ::Liquid::Tag
          Syntax = /(#{::Liquid::Expression}+)?/
          def initialize(tag_name, markup, tokens)
            if markup =~ Syntax
              @javascript = $1.gsub('\'', '')
            else
              raise ::Liquid::SyntaxError.new("Syntax Error in 'javascript_include_tag' - Valid syntax: javascript_include_tag <javascript>")
            end
            super
          end

          def render(context)
            controller  = context.registers[:controller]
            controller.view_context.send(:javascript_include_tag, @javascript)
          end
        end

        class SmithyJavascriptIncludeTag < ::Liquid::Tag
          Syntax = /(#{::Liquid::Expression}+)?/
          def initialize(tag_name, markup, tokens)
            if markup =~ Syntax
              @javascript = $1.gsub('\'', '')
              @javascript = "#{@javascript}.js" unless @javascript.match(/\.js$/)
            else
              raise ::Liquid::SyntaxError.new("Syntax Error in 'smithy_javascript_include_tag' - Valid syntax: smithy_javascript_include_tag <javascript>")
            end
            super
          end

          def render(context)
            "<script src=\"/templates/javascripts/#{@javascript}\" type=\"text/javascript\"></script>"
          end
        end
        class SmithyStylesheetLinkTag < ::Liquid::Tag
          Syntax = /(#{::Liquid::Expression}+)?/
          def initialize(tag_name, markup, tokens)
            if markup =~ Syntax
              @stylesheet = $1.gsub('\'', '')
              @stylesheet = "#{@stylesheet}.css" unless @stylesheet.match(/\.css$/)
            else
              raise ::Liquid::SyntaxError.new("Syntax Error in 'stylesheet_link_tag' - Valid syntax: stylesheet_link_tag <stylesheet>")
            end
            super
          end

          def render(context)
            "<link href=\"/templates/stylesheets/#{@stylesheet}\" media=\"screen\" rel=\"stylesheet\" type=\"text/css\">"
          end
        end
      end
      ::Liquid::Template.register_tag('stylesheet_link_tag', Html::StylesheetLinkTag)
      ::Liquid::Template.register_tag('javascript_include_tag', Html::JavascriptIncludeTag)
      ::Liquid::Template.register_tag('smithy_javascript_include_tag', Html::SmithyJavascriptIncludeTag)
      ::Liquid::Template.register_tag('smithy_stylesheet_link_tag', Html::SmithyStylesheetLinkTag)
    end
  end
end
