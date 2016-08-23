
module Smithy
  module Liquid
    module Tags
      module Html
        class Base < ::Liquid::Tag
          Syntax = /(#{::Liquid::Expression}+)?/
          def initialize(tag_name, markup, tokens)
            if markup =~ Syntax
              @tag = $1.gsub('\'', '')
            else
              raise ::Liquid::SyntaxError.new("Syntax Error in '#{tag_name}' - Valid syntax: #{tag_name} <path_to/your_file>")
            end
            super
          end

          def tag
            @tag
          end

          def tag_with_ext(ext)
            tag.match(/\.#{ext}$/) ? tag : "#{tag}.#{ext}"
          end

          def tag_without_ext(ext)
            tag.sub(/\.#{ext}$/, '')
          end

          def render(context)
            raise Error.new("please override Smithy::Liquid::Tag::Html::Base#render")
          end
        end

        class StylesheetLinkTag < Base
          def render(context)
            controller = context.registers[:controller]
            controller.view_context.send(:stylesheet_link_tag, tag)
          end
        end
        class JavascriptIncludeTag < Base
          def render(context)
            controller = context.registers[:controller]
            controller.view_context.send(:javascript_include_tag, tag)
          end
        end
        class SmithyJavascriptIncludeTag < Base
          def render(context)
            controller = context.registers[:controller]
            javascript = Smithy::Template.javascripts.find_by(name: tag_without_ext('js'))
            path = "/templates/javascripts/#{tag_with_ext('js')}"
            path += "?#{javascript.updated_at.to_s(:number)}" if javascript.present?
            controller.view_context.send(:javascript_include_tag, path)
          end
        end
        class SmithyStylesheetLinkTag < Base
          def render(context)
            controller = context.registers[:controller]
            stylesheet = Smithy::Template.stylesheets.find_by(name: tag_without_ext('css'))
            path = "/templates/stylesheets/#{tag_with_ext('css')}"
            path += "?#{javascript.updated_at.to_s(:number)}" if stylesheet.present?
            controller.view_context.send(:stylesheet_link_tag, path)
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
