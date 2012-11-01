module Smithy
  class PageContent < ActiveRecord::Base
    attr_accessible :label, :container, :content_block_type, :content_block_attributes, :content_block_template_id, :position

    validates_presence_of :label, :container, :page
    validates_presence_of :content_block, :content_block_template, :on => :update

    belongs_to :page
    belongs_to :content_block, :polymorphic => true
    belongs_to :content_block_template

    accepts_nested_attributes_for :content_block, :allow_destroy => true

    default_scope order(:position).order(:id)
    scope :for_container, lambda {|container| where(:container => container) }

    def attributes=(attributes = {})
      self.content_block_type = attributes[:content_block_type]
      super
    end

    def content_block_attributes=(attributes)
      klass = content_block_type.safe_constantize || "Smithy::#{content_block_type}".safe_constantize
      if klass
        self.content_block = klass.find_or_initialize_by_id(attributes.delete(:id))
        self.content_block.attributes = attributes
        self.content_block
      end
    end

    def render
      content_block_template.liquid_template.render(self.to_liquid)
    end

    def to_liquid
      content_block.attributes
    end

    def templates
      unless @templates
        @templates = []
        if Smithy::ContentBlock.find_by_name(self.content_block_type.demodulize)
          @templates = Smithy::ContentBlock.find_by_name(self.content_block_type.demodulize).templates
        end
      end
      @templates
    end
  end
end
