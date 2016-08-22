module Smithy
  class PageContent < ActiveRecord::Base
    validates_presence_of :content_block, :content_block_template, :on => :update
    validates_presence_of :content_block_type, :on => :create
    validates_presence_of :label, :container, :page

    belongs_to :page, :touch => true
    belongs_to :content_block, :polymorphic => true
    belongs_to :content_block_template

    before_update :set_publishable

    accepts_nested_attributes_for :content_block, :allow_destroy => true
    amoeba do
      enable
      include_association :content_block
    end

    default_scope -> { order(:position).order(:id) }
    scope :for_container, ->(container) { where(:container => container) }
    scope :publishable, -> { where(:publishable => true) }

    def attributes=(attributes = {})
      self.content_block_type = attributes[:content_block_type]
      super
    end

    def content_block_attributes=(attributes)
      return unless attributes.present?
      klass = content_block_type.safe_constantize || "Smithy::#{content_block_type}".safe_constantize
      if klass
        self.content_block = klass.find_or_initialize_by(id: attributes.delete(:id))
        self.content_block.attributes = attributes
        self.content_block
      end
    end

    def render(liquid_context)
      liquid_context.stack do
        # push the default assigns into a smithy namespace. They'll still be in the
        # scopes as the original values as well, but this ensures they don't get clobbered
        liquid_context.merge('smithy' => liquid_context.scopes.last)
        liquid_context.merge(self.to_liquid)
        output = content_block_template.liquid_template.render(liquid_context)
        # auto-wrap every page content in a div with the page_content-#id and the page_content#css_classes
        wrapper = Smithy::PageContentWrapper.new(self)
        wrapper.wrap(output)
      end
    end

    def to_liquid
      if content_block.respond_to?(:to_liquid)
        content_block.to_liquid
      else
        content_block.attributes
      end
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

    private
      def set_publishable
        self.publishable = true if self.content_block
      end
  end
end
