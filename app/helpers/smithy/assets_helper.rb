module Smithy
  module AssetsHelper
    def asset_image_tag(asset_id)
      asset = Smithy::Asset.find_by_id(asset_id)
      return unless asset
      image_tag(asset.url, :alt => asset.name)
    end

    def asset_preview_link(asset_id)
      asset = Smithy::Asset.find_by_id(asset_id)
      return unless asset
      link_to attachment_url(asset, :file) do
        if asset.file_type == :image
          attachment_image_tag(asset, :file, :fit, 48, 48, alt: '')
        elsif asset.file_type == :direct_image
          attachment_image_tag(asset, :file, width: 48, alt: '')
        else
          image_tag file_type_icon(asset), alt: ''
        end
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
