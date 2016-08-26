module Smithy
  class PermittedParams < Struct.new(:params, :user)
    def params_for(param)
      param = param.to_sym
      attributes = send("#{param.to_s}_attributes".to_sym)
      if attributes == :all
        params.fetch(param, {}).permit!
      elsif attributes.respond_to? :call
        attributes.call
      else
        params.fetch(param, {}).permit( *attributes )
      end
    end

    def asset_attributes
      [ :name, :file, :file_name, :file_url, :retained_file, :uploaded_file_url ]
    end

    def asset_source_attributes
      [ :name, assets_files: [] ]
    end

    def content_attributes
      [ :content ]
    end

    def content_block_attributes
      [ :name, templates_attributes: [ :id, :name, :content, :_destroy ] ]
    end

    def content_block_template_attributes
      [ :name, :content ]
    end

    def image_attributes
      [ :alternate_text, :asset_id, :height, :html_attributes, :image_scaling, :link_url, :width, :content ]
    end

    def page_attributes
      # :all
      [
        :browser_title, :cache_length, :description, :external_link, :keywords, :permalink, :publish, :published_at, :show_in_navigation, :title, :parent_id, :template_id, :copy_content_from,
        contents_attributes: nested_attributes(:page_content)
      ]
    end

    def page_content_attributes
      attributes = [ :label, :css_classes, :container, :content_block_type, :content_block_template_id, :position ]
      if params[:content_block_type].present?
        attributes << { content_block_attributes: [:id] + content_block_attributes + content_block_attributes_for(params[:content_block_type]) + [ :_destroy ] }
      end
      attributes
    end

    def page_list_attributes
      [ :count, :page_template_id, :parent_id, :include_children, :sort ]
    end

    def setting_attributes
      [ :name, :value ]
    end

    def template_attributes
      [ :name, :content, :template_type ]
    end

    def template_container_attributes
      [ :name, :position ]
    end

    def content_block_attributes_for(content_block_type)
      klass = content_block_type.safe_constantize || "Smithy::#{content_block_type}".safe_constantize
      content_block_attributes += klass.column_names.delete_if { |n| n.to_s.presence_in %w(id updated_at created_at) }.map(&:to_sym)
      klass.reflections.delete_if{|k,v| k.to_s.presence_in %w(id page_contents pages) }.each do |name,association|
        association_attributes << {"#{name}_attributes".to_sym => association.klass.column_names.delete_if { |n| n.to_s.presence_in %w(updated_at created_at) }.map(&:to_sym) + [:_destroy] }
      end
      # ContentBlocks::Registry.content_blocks.inject([]) do |association_attributes, content_block_type|
      #   klass = content_block_type.safe_constantize || "Smithy::#{content_block_type}".safe_constantize
      #   content_block_attributes += klass.column_names.delete_if { |n| n.to_s.presence_in %w(id updated_at created_at) }.map(&:to_sym)
      #   klass.reflections.delete_if{|k,v| k.to_s.presence_in %w(id page_contents pages) }.each do |name,association|
      #     association_attributes << {"#{name}_attributes".to_sym => association.klass.column_names.delete_if { |n| n.to_s.presence_in %w(updated_at created_at) }.map(&:to_sym) + [:_destroy] }
      #   end
      # end
    end

    def nested_attributes(object_name)
      send("#{object_name}_attributes".to_sym) + [ :id, :_destroy ]
    end
  end
end
