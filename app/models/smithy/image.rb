module Smithy
  class Image < ActiveRecord::Base
    include Smithy::ContentBlocks::Model

    attr_accessible :alternate_text, :height, :image_scaling, :link_url, :width

    validates_presence_of :asset

    belongs_to :asset
  end
end
