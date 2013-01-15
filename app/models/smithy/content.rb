module Smithy
  class Content < ActiveRecord::Base
    include Smithy::ContentBlocks::Model

    attr_accessible :content

    validates_presence_of :content

    before_save :render_markdown_content

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
        renderer = Redcarpet::Render::SmartyHTML.new(filter_html: false, safe_links_only: true)
        extensions = {
          autolink: true,
          no_intra_emphasis: true,
          fenced_code_blocks: true,
          lax_spacing: true,
          strikethrough: true,
          superscript: true,
          tables: true
        }
        self.markdown_content = Redcarpet::Markdown.new(renderer, extensions).render(self.content)
      end
  end
end
