module Smithy
  module Liquid
    module Tags
      class Nav < ::Liquid::Tag
        Syntax = /(#{::Liquid::Expression}+)?/

        # {% nav site|page, id: 'main-nav', depth: 1, class: 'nav', active_class: 'on', include_root: 'true' }
        def initialize(tag_name, markup, tokens)
          @options = { :id => 'nav', :depth => 1, :class => '', :active_class => 'on', :include_root => false }
          if markup =~ Syntax
            @source = ($1 || 'site').gsub(/"|'/, '')
            markup.scan(::Liquid::TagAttributes) do |key, value|
              @options[key.to_sym] = value.gsub(/"|'/, '')
            end
            @options[:depth] = @options[:depth].to_i
            @options[:depth] = 100 if @options[:depth] == 0
            @options[:wrapper] = @options[:wrapper] == "false" ? false : true
            @options[:include_root] = @options[:include_root] == "true" ? true : false
          else
            raise ::Liquid::SyntaxError.new("Syntax Error in 'nav' - Valid syntax: nav <site|page|section> <options>")
          end
          super
        end

        def parse(tokens)
          @tokens = tokens
        end

        def render(context)
          @site = context.registers[:site]
          @page = context.registers[:page]
          @controller = context.registers[:controller]
          list_items = render_list_items(root_node)
          @options[:wrapper] ? render_wrapper(list_items, @options[:id]) : list_items
        end

        def render_children(parent, depth)
          list_items = render_list_items(parent, depth)
          return unless list_items.present?
          render_wrapper(list_items)
        end

        def render_list_item(item, depth)
          item_id = "#{@options[:id]}-#{item.permalink}"
          href = item.url
          label = item.title
          css_class = " class=\"#{@options[:active_class]}\"" if (@page && @page.id == item.id) || (@controller && [item.path, item.external_link].include?(@controller.request.path))
          %Q{#{"  " * depth}<li id="#{item_id}"#{css_class}><a href="#{href}" id="#{item_id}-link">#{label}</a>#{render_children(item, depth.succ)}</li>}
        end

        def render_list_items(parent, depth=1)
          return if depth > @options[:depth] || parent.leaf?
          items = []
          items << render_list_item(parent, depth) if depth == 1 && @options[:include_root]
          parent.children.included_in_navigation.inject(items) do |items, item|
            items << render_list_item(item, depth)
          end.join("\n")
        end

        def render_wrapper(list_items, id = nil)
          list_id = id.present? ? " id=\"#{id}\"" : ''
          %Q{<ul#{list_id}>\n#{list_items}\n</ul>}
        end

        def root_node
          case @source
          when 'site'
            Smithy::Page.root
          when 'page'
            @page
          when 'section'
            @page == Smithy::Page.root ? @page : @page.self_and_ancestors.second
          end
        end

      end
      ::Liquid::Template.register_tag('nav', Nav)
    end
  end
end
