module Smithy
  module AssetsHelper
    def asset_image_tag(asset_id)
      asset = Smithy::Asset.find_by_id(asset_id)
      return unless asset
      image_tag(asset.file.url, :alt => asset.name)
    end
  end
end
