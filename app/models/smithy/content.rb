module Smithy
  class Content < ActiveRecord::Base
    include Smithy::ContentBlocks::Model
    attr_accessible :content

    validates_presence_of :content
  end
end
