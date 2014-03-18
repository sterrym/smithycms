require_dependency "smithy/base_controller"

module Smithy
  class TemplatesController < BaseController
    skip_before_filter :authenticate_smithy_admin, :only => [ :javascript, :stylesheet ]
    before_filter :load_templates
    respond_to :html, :json

    def index
      respond_with @templates
    end

    def new
      @template = Template.new(filtered_params)
      respond_with @template
    end

    def create
      @template = Template.new(filtered_params)
      @template.save
      flash.notice = "Your template was created" if @template.persisted?
      respond_with @template do |format|
        format.html { redirect_to [:edit, @template] }
      end
    end

    def edit
      @template = Template.find(params[:id])
      @template_editor_type = case @template.template_type
      when 'javascript'
        'javascript'
      when 'stylesheet'
        'css'
      else
        'liquid'
      end
      respond_with @template
    end

    def update
      @template = Template.find(params[:id])
      flash.notice = "Your template was saved" if @template.update_attributes(filtered_params)
      respond_with @template do |format|
        format.html { redirect_to [:edit, @template] }
      end
    end

    def destroy
      @template = Template.find(params[:id])
      @template.destroy
      respond_with @template
    end

    def javascript
      @javascript = Template.javascripts.find_by(name: params[:javascript].sub(/\.js$/, ''))
      render_asset_template(@javascript, params[:javascript], 'text/javascript')
    end

    def stylesheet
      @stylesheet = Template.stylesheets.find_by(name: params[:stylesheet].sub(/\.css$/, ''))
      render_asset_template(@stylesheet, params[:stylesheet], 'text/css')
    end

    private
      def load_templates
        @templates = Template.templates
        @includes = Template.partials
        @javascripts = Template.javascripts
        @stylesheets = Template.stylesheets
      end

      def render_asset_template(template, template_name, content_type)
        raise ActiveRecord::RecordNotFound, "No such stylesheet '#{template_name}'" unless template.present?
        expires_in(2592000.seconds, :public => true) # cache for 30 days
        headers['X-Content-Digest'] = Digest::SHA1.hexdigest(template.content) # digest of the content for cache control when the template changes
        render :text => template.content, :content_type => content_type
      end
  end
end
