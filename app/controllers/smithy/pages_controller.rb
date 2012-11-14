require_dependency "smithy/application_controller"

module Smithy
  class PagesController < ApplicationController
    before_filter :initialize_page, :only => [ :new, :create ]
    before_filter :load_page, :only => [ :edit, :update, :destroy ]
    before_filter :load_parent, :except => [ :index, :show, :root ]
    before_filter :load_root, :only => [ :index ]
    respond_to :html, :json

    def index
      respond_with @root
    end

    def show
      @page ||= Page.find(params[:path].present? ? "/#{params[:path]}" : params[:id])
      respond_with @page do |format|
        format.html { render_smithy_page }
      end
    end

    def new
      respond_with @page
    end

    def create
      @page.save
      flash.notice = "Your page was created" if @page.persisted?
      respond_with @page do |format|
        format.html { @page.persisted? ? redirect_to(edit_page_path(@page.id)) : render(:action => 'new') }
      end
    end

    def edit
      respond_with @page
    end

    def update
      flash.notice = "Your page was saved" if @page.update_attributes(params[:page])
      respond_with @page do |format|
        format.html { redirect_to edit_page_path(@page.id) }
      end
    end

    def destroy
      @page.destroy
      respond_with @page
    end

    def root
      @page = Page.root
      show
    end

    private
      def initialize_page
        @page = Page.new(params[:page])
      end

      def load_page
        @page = Page.find(params[:id])
        @root = @page if Page.root == @page
      end

      def load_parent
        @parent = @page.parent
      end

      def load_root
        @root = Page.root
      end

      def render_smithy_page
        context = ::Liquid::Context.new({}, smithy_default_assigns, smithy_default_registers, false)
        output = @page.template.liquid_template.render(context)
        render :text => output, :layout => false
      end

      def smithy_default_assigns
        {
          'page'              => @page,
          'current_page'      => self.params[:path],
          'params'            => self.params,
          'path'              => request.path,
          'fullpath'          => request.fullpath,
          'url'               => request.url,
          'now'               => Time.now.utc,
          'today'             => Date.today,
        }
      end

      def smithy_default_registers
        {
          :controller => self,
          :page => @page,
          :site => Smithy::Site.new,
        }
      end
  end
end
