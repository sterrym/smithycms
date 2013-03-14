require_dependency "smithy/application_controller"

module Smithy
  class TemplatesController < ApplicationController
    before_filter :load_templates
    respond_to :html, :json

    def index
      respond_with @templates
    end

    def new
      @template = Template.new(params[:template])
      respond_with @template
    end

    def create
      @template = Template.new(params[:template])
      @template.save
      flash.notice = "Your template was created" if @template.persisted?
      respond_with @template do |format|
        format.html { redirect_to [:edit, @template] }
      end
    end

    def edit
      @template = Template.find(params[:id])
      respond_with @template
    end

    def update
      @template = Template.find(params[:id])
      flash.notice = "Your template was saved" if @template.update_attributes(params[:template])
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
      @javascript = Template.javascripts.find_by_name(params[:javascript].sub(/\.js$/, ''))
      raise ActiveRecord::RecordNotFound, "No such javascript '#{params[:javascript]}'" unless @javascript.present?
      render :text => @javascript.content, :content_type => "text/javascript"
    end

    def stylesheet
      @stylesheet = Template.stylesheets.find_by_name(params[:stylesheet].sub(/\.css$/, ''))
      raise ActiveRecord::RecordNotFound, "No such stylesheet '#{params[:stylesheet]}'" unless @stylesheet.present?
      render :text => @stylesheet.content, :content_type => "text/css"
    end

    private
      def load_templates
        @templates = Template.templates
        @includes = Template.partials
        @javascripts = Template.javascripts
        @stylesheets = Template.stylesheets
      end
  end
end
