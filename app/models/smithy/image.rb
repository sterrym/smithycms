module Smithy
  class Image < ActiveRecord::Base
    include Smithy::ContentBlocks::Model

    attr_accessible :alternate_text, :asset_id, :height, :image_scaling, :link_url, :width

    validates_presence_of :asset

    belongs_to :asset

    class << self
      def image_scaling_options
        [
          ['Keep to Scale', ''],
          ['Force Exact Dimensions (this may crop the image)', '#']
        ]
      end
    end

    def to_liquid
      attributes.tap do |a|
        a['asset'] = asset.to_liquid if asset.present?
      end
    end
  end
end
