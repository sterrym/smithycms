require_dependency "tagcms/application_controller"

module Tagcms
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
        format.html { redirect_to templates_path }
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

    private
      def load_templates
        @templates = Template.where(:template_type => "template")
        @includes = Template.where(:template_type => "include")
      end
  end
end
