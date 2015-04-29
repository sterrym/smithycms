module Smithy
  module Liquid
    module Tags
      module Asset
        class AssetImageTag < ::Liquid::Tag
          Syntax = /(#{::Liquid::Expression}+)?/
          def initialize(tag_name, markup, tokens)
            if markup =~ Syntax
              @asset_id = $1.gsub('\'', '').strip
              if @asset = ::Smithy::Asset.find_by_id(@asset_id)
                @url = @asset.file.url
                @alt = @asset.name
              else
                @url = @asset_id
                @alt = ''
              end
            else
              raise ::Liquid::SyntaxError.new("Syntax Error in '#{@tag_name}' - Valid syntax: asset_image_tag <asset_id|path>")
            end
            super
          end

          def render(context)
            controller  = context.registers[:controller]
            controller.view_context.send(:image_tag, @url, :alt => @alt)
          end
        end
        class AssetFilePath < ::Liquid::Tag
          Syntax = /(#{::Liquid::Expression}+)?/
          def initialize(tag_name, markup, tokens)
            if markup =~ Syntax
              @asset_id = $1.gsub('\'', '')
              if @asset = ::Smithy::Asset.find_by_id(@asset_id)
                @url = @asset.file.url
              else
                @url = @asset_id
              end
            else
              raise ::Liquid::SyntaxError.new("Syntax Error in '#{@tag_name}' - Valid syntax: asset_file_path <asset_id|path>")
            end
            super
          end

          def render(context)
            @url
          end
        end
      end
      ::Liquid::Template.register_tag('asset_image_tag', Asset::AssetImageTag)
      ::Liquid::Template.register_tag('asset_image_path', Asset::AssetFilePath)
      ::Liquid::Template.register_tag('asset_file_path', Asset::AssetFilePath)
    end
  end
end
