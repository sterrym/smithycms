module Smithy
  class PageContent < ActiveRecord::Base
    attr_accessible :label, :container, :content_block, :position

    validates_presence_of :label, :container, :page
    validates_presence_of :content_block, :on => :update

    belongs_to :page
    belongs_to :content_block, :polymorphic => true

    accepts_nested_attributes_for :content_block, :reject_if => lambda {|a| a['id'].blank? }, :allow_destroy => true

    default_scope order(:position).order(:id)
    scope :for_container, lambda {|container| where(:container => container) }

    def render
      # TODO: render content pieces using the template and content from the associated content block
      nil
    end
  end
end
