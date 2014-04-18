module Smithy
  class Image < ActiveRecord::Base
    include Smithy::ContentBlocks::Model

    validates_presence_of :asset

    belongs_to :asset

    class << self
      def content_block_description
        "Images are primarily used for adding image-based content to your pages"
      end

      def image_scaling_options
        [
          ['Keep to Scale', ''],
          ['Force Exact Dimensions (this may crop the image)', '#']
        ]
      end
    end

    def formatted_content
      @formatted_content ||= markdown_formatter.render
    end

    def to_liquid
      attributes.tap do |a|
        a['asset'] = asset.to_liquid if asset.present?
        a['formatted_content'] = formatted_content
      end
    end

    private
      def markdown_formatter
        @markdown_formatter ||= Smithy::Formatter.new(self.content)
      end
  end
end
