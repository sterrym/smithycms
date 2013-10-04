module Smithy
  module Liquid
    module Drops
      class Page < Base
        delegate :title, :depth, :permalink, :to => '_source'

        def breadcrumbs
          self._source.ancestors.where(["#{self._source.class.quoted_table_name}.#{self._source.class.primary_key} != ?", self._source.class.root]).map(&:to_liquid)
        end

        def browser_title
          self._source.browser_title.present? ? self._source.browser_title : self._source.generated_browser_title
        end

        def children
          self._source.children.map(&:to_liquid)
        end

        def container
          self._source.rendered_containers
        end

        def meta_description
          self._source.description
        end

        def meta_keywords
          self._source.keywords
        end

        def parent
          self._source.parent.to_liquid
        end

        def path
          self._source.url
        end

        def published?
          self._source.published?
        end

        def show_in_navigation?
          self._source.show_in_navigation?
        end

        def root?
          self._source.root?
        end

        def leaf?
          self._source.leaf?
        end

        def child?
          self._source.child?
        end
      end
    end
  end
end
