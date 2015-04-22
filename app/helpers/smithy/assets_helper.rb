module Smithy
  module AssetsHelper
    def asset_image_tag(asset_id)
      asset = Smithy::Asset.find_by_id(asset_id)
      return unless asset
      image_tag(asset.file.url(:host => "#{request.protocol}#{request.host_with_port}"), :alt => asset.name)
    end

    def smithy_asset_file_field()
      html = content_tag(:div, :id => "asset_file_fields_blueprint", :style => "display:none;") do
        render partial: 'smithy/assets/inline_form'
      end
    end



    def file_type_icon(asset)
      case asset.file_type
      when :image
        nil
      when :pdf
        'smithy/icons/pdf.png'
      when :word
        'smithy/icons/doc.png'
      when :excel
        'smithy/icons/xls.png'
      when :powerpoint
        'smithy/icons/ppt.png'
      when :text
        'smithy/icons/txt.png'
      when :document
        'smithy/icons/_page.png'
      when :default
        'smithy/icons/_blank.png'
      end
    end
  end
end
