module Smithy
  module ApplicationHelper
    def link_to_add_fields(name, association, form_builder)
      html = content_tag(:div, :id => "#{association}_fields_blueprint", :style => "display:none;") do
        form_builder.semantic_fields_for(association, model_object(form_builder, association), :child_index => "new_#{association}") do |builder|
          form_builder.template.concat(raw render("#{form_builder.object.class.to_s.tableize}/#{association.to_s.singularize}_fields", :f => builder))
        end
      end
      form_builder.template.concat(html)
      form_builder.template.link_to(name, "javascript:void(0)", :class => "add_nested_fields", "data-association" => association)
    end

    def link_to_remove_fields(name, form_builder)
      form_builder.hidden_field(:_destroy) + @template.link_to(name, "javascript:void(0)", :class => "remove_nested_fields")
    end

    def render_markdown_input(fieldname, editor_name, form_builder)
      content_for(:javascript) do
        javascript_tag do
          raw("var editor = ace_edit('#{form_builder.object.id || 'new'}', 'markdown', '#{editor_name}');\n") +
          raw("editor.renderer.setShowGutter(false);")
        end
      end
      hint = "Use markdown syntax for formatting. You can also use HTML directly. <a href=\"#{guide_path('markdown')}\" data-toggle=\"remote-load\" data-target=\"#content-guide\">See our markdown syntax reference</a>".html_safe
      form_builder.input(fieldname, :as => :text, :input_html => { :class => "span12", :id => "#{editor_name}-#{form_builder.object.id || 'new'}" }, :hint => hint) +
      content_tag(:div, nil, :id => "#{editor_name}_editor-#{form_builder.object.id || 'new'}", :class => "#{editor_name}_editor ace_editor") +
      content_tag(:div, nil, :id => 'content-guide')
    end

    private
      def model_object(form_builder, association)
        model_object = form_builder.object.class.reflect_on_association(association).klass.new
      end

  end
end
