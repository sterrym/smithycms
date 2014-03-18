module Smithy
  class Content < ActiveRecord::Base
    include Smithy::ContentBlocks::Model

    validates_presence_of :content

    before_save :render_markdown_content

    class << self
      def content_block_description
        "Content is primarily used for adding text-based content to your pages"
      end
    end

    def formatted_content
      self.markdown_content
    end

    def to_liquid
      {
        'id' => self.id,
        'content' => self.content,
        'formatted_content' => self.formatted_content
      }
    end

    private
      def render_markdown_content
        formatter = Smithy::Formatter.new(self.content)
        self.markdown_content = formatter.render
      end
  end
end
