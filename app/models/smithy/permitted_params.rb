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

    def content_attributes
      [ :content ]
    end

    def content_block_attributes
      # [ :name, templates_attributes: [ :id, :name, :content, :_destroy ] ]
      :all
    end

    def content_block_template_attributes
      [ :content, :name ]
    end

    def image_attributes
      [ :alternate_text, :asset_id, :height, :html_attributes, :image_scaling, :link_url, :width, :content ]
    end

    def page_attributes
      [ :browser_title, :cache_length, :description, :external_link, :keywords, :permalink, :publish, :published_at, :show_in_navigation, :title, :parent_id, :template_id ]
    end

    def page_content_attributes
      # [ :label, :container, :content_block_type, :content_block_template_id, :position ]
      :all
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
  end
end
