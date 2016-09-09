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
      [
        :browser_title, :cache_length, :description, :external_link, :keywords, :permalink, :publish, :published_at, :show_in_navigation, :title, :parent_id, :template_id, :copy_content_from,
        contents_attributes: page_content_attributes + [:id, :_destroy]
      ]
    end

    def page_content_attributes
      attributes = [ :label, :css_classes, :container, :content_block_type, :content_block_template_id, :position ]
      content_block_attributes = ::Smithy::ContentBlocks::Registry.content_blocks.inject([]) do |association_attributes, content_block_type|
        association_attributes += nested_content_block_attributes_for(content_block_type)
      end
      attributes << { content_block_attributes: content_block_attributes + [:id, :_destroy] } if content_block_attributes.present?
      byebug
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

    private
      def content_block_attributes_for(content_block_type)
        attributes_method = "#{content_block_type.underscore}_attributes".to_sym
        byebug
        if self.respond_to?(attributes_method)
          public_send(attributes_method)
        else
          klass = "Smithy::#{content_block_type.singularize.camelize}".safe_constantize || content_block_type.singularize.camelize.safe_constantize
          klass.present? ? klass.column_names.delete_if { |n| n.to_s.presence_in %w(id updated_at created_at) }.map(&:to_sym) : []
        end
      end

      def nested_content_block_attributes_for(content_block_type)
        content_block_attributes = content_block_attributes_for(content_block_type)
        association_attributes = []
        reflected_content_block_associations(content_block_type).each do |reflection|
          name, association = reflection
          byebug
          next if association.active_record.nested_attributes_options[name.to_sym].blank?
          allowed_attributes = content_block_attributes_for(name) + [:id]
          allowed_attributes += [:_destroy] if association.active_record.nested_attributes_options[name.to_sym][:allow_destroy] == true
          association_attributes << {"#{name}_attributes".to_sym => allowed_attributes }
        end
        content_block_attributes += association_attributes
        content_block_attributes.uniq
      end

      def reflected_content_block_associations(content_block_type)
        klass = "Smithy::#{content_block_type}".safe_constantize || content_block_type.safe_constantize
        reflections = klass.reflections.delete_if{|k,v| k.to_s.presence_in %w(id page_contents pages) }
      end

  end
end
