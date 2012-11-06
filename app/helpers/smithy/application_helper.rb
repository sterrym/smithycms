module Smithy
  module ApplicationHelper
    def link_to_add_fields(name, association, form_builder)
      @fields ||= {}
      model_object = form_builder.object.class.reflect_on_association(association).klass.new
      form_builder.template.concat(raw %Q[<div id="#{association}_fields_blueprint" style="display:none;">])
      fields = form_builder.semantic_fields_for(association, model_object, :child_index => "new_#{association}") do |builder|
        form_builder.template.concat(raw render(association.to_s.singularize + "_fields", :f => builder))
      end
      form_builder.template.concat(fields)
      form_builder.template.concat(raw '</div>')
      form_builder.template.link_to(name, "javascript:void(0)", :class => "add_nested_fields", "data-association" => association)
    end

    def link_to_remove_fields(name, form_builder)
      form_builder.hidden_field(:_destroy) + @template.link_to(name, "javascript:void(0)", :class => "remove_nested_fields")
    end

  end
end
