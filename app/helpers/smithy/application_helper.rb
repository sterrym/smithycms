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

    private
      def model_object(form_builder, association)
        model_object = form_builder.object.class.reflect_on_association(association).klass.new
      end

  end
end
