module Smithy
  class Image < ActiveRecord::Base
    validates_presence_of :asset

    include Smithy::ContentBlocks::Model
    belongs_to :asset
    attr_accessible :alternate_text, :height, :image_scaling, :link_url, :width


  end
end
