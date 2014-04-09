module Smithy
  module Liquid
    module Drops
      class Page < Base
        delegate :title, :depth, :permalink, :root, :site, :to => '_source'

        def breadcrumbs
          self._source.ancestors.where(["id != ?", root]).map(&:to_liquid)
        end

        def browser_title
          self._source.browser_title.present? ? self._source.browser_title : self.generated_browser_title
        end

        def children
          self._source.children.map(&:to_liquid)
        end

        def container
          self.rendered_containers
        end

        def meta_description
          self._source.description
        end

        def meta_keywords
          self._source.keywords
        end

        def next
          sibling = if self._source.leaf?
            self._source.right_sibling
          elsif self._source.children.size
            self._source.children.first
          end
          sibling ||= self._source.parent.right_sibling
          sibling.to_liquid
        end

        def next_sibling
          self._source.right_sibling.to_liquid
        end

        def parent
          self._source.parent.to_liquid
        end

        def path
          self._source.url
        end

        def previous
          sibling = if self._source.left_sibling && self._source.left_sibling.leaf?
            self._source.left_sibling
          elsif self._source.left_sibling && self._source.left_sibling.children.size
            self._source.left_sibling.children.last
          end
          sibling ||= self._source.parent
          sibling.to_liquid
        end

        def previous_sibling
          sibling = self._source.left_sibling.to_liquid
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

        protected
          def generated_browser_title
            @generated_browser_title ||= generated_browser_titles.join(' | ')
          end

          def rendered_containers
            Hash[ *_source.containers.map(&:name).map{|cn| [cn, _source.render_container(cn) ] }.flatten ]
          end

        private
          def generated_browser_titles
            titles = _source.self_and_ancestors.map(&:title)
            titles.shift unless _source.root? # keep all except the first element unless root
            titles << site.title if site.title.present?
            titles
          end
      end
    end
  end
end
