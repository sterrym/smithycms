module Smithy
  class PageList < ActiveRecord::Base
    include Smithy::ContentBlocks::Model

    validates_presence_of :parent_id

    belongs_to :parent, :class_name => "Page"

    class << self
      def content_block_description
        "Page Lists are primarily used to provide a sub-navigation for parent pages or cross-navigation to other sections of your website."
      end

      def sort_options
        [
          ['Sitemap Order', 'sitemap'],
          ['Most Recently Created First', 'created_desc'],
          ['Earliest Created First', 'created_asc'],
          ['Alphabetical Order', 'title_asc'],
          ['Reverse Alphabetical Order', 'title_desc']
        ]
      end
    end

    def pages
      unless @pages
        return unless self.parent
        @pages = self.parent.children
        @pages = @pages.except(:order).order(sort_sql) unless sort_sql.nil?
        @pages = @pages.limit(self.count) if self.count?
        @pages = @pages.where(:template_id => self.page_template_id) if self.page_template_id?
      end
      @pages
    end

    def to_liquid
      {
        'id' => self.id,
        'parent' => self.parent,
        'pages' => self.pages
      }
    end

    private
      def sort_sql
        case self.sort
        when 'created_desc'
          'created_at DESC'
        when 'created_asc'
          'created_at ASC'
        when 'title_asc'
          'title ASC'
        when 'title_desc'
          'title DESC'
        end
      end

  end
end
