module Smithy
  class AssetSource < ActiveRecord::Base
    has_many :assets, :dependent => :destroy

    accepts_attachments_for :assets, append: true
  end
end
