module Smithy
  class Content < ActiveRecord::Base
    attr_accessible :content

    validates_presence_of :content

    has_many :page_contents, :as => :content_block
  end
end
