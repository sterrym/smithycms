module Tagcms
  class PageContent < ActiveRecord::Base
    attr_accessible :container, :content_block, :position

    validates_presence_of :container, :content_block

    belongs_to :page
    belongs_to :content_block, :polymorphic => true

    default_scope order(:position).order(:id)

    def render
      # TODO: render content pieces using the template and content from the associated content block
      nil
    end
  end
end
