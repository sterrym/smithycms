module Smithy
  class ContentBlockTemplate < ActiveRecord::Base
    belongs_to :content_block, :touch => true
    has_many :page_contents

    validates_presence_of :name
    validates_uniqueness_of :name, :scope => :content_block_id
    validates_presence_of :content

    after_save :touch_page_contents

    default_scope -> { order(:name) }

    def liquid_template
      @liquid_template ||= ::Liquid::Template.parse(content_with_fixed_asset_links)
    end

    private
      def content_with_fixed_asset_links
        Smithy::AssetLink.fix(self.content)
      end

      def touch_page_contents
        self.page_contents.each(&:touch)
      end

  end
end
