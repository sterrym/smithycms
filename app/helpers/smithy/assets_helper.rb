module Smithy
  module AssetsHelper
    def asset_image_tag(asset_id)
      asset = Smithy::Asset.find_by_id(asset_id)
      return unless asset
      image_tag(asset.file.url(:host => "#{request.protocol}#{request.host_with_port}"), :alt => asset.name)
    end
  end
end
