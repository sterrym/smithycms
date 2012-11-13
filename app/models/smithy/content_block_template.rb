module Smithy
  class ContentBlockTemplate < ActiveRecord::Base
    attr_accessible :content, :name

    belongs_to :content_block

    validates_presence_of :name
    validates_uniqueness_of :name, :scope => :content_block_id
    validates_presence_of :content

    default_scope order(:name)

    def liquid_template
      @liquid_template ||= ::Liquid::Template.parse(self.content)
    end
  end
end
