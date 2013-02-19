require_dependency "smithy/application_controller"

module Smithy
  class PagesController < ApplicationController
    skip_before_filter :authenticate_smithy_admin, :only => [ :show ]
    include Smithy::Liquid::Rendering
    before_filter :initialize_page, :only => [ :new, :create ]
    before_filter :load_page, :only => [ :edit, :update, :destroy ]
    before_filter :load_parent, :except => [ :index, :show, :order ]
    before_filter :load_root, :only => [ :index ]
    respond_to :html, :json

    def index
      respond_with @root
    end

    def show
      params[:path] = '' if params[:id].nil? && params[:path].nil? # sets the root path when nothing else is passed
      @page = Page.find(params[:path].nil? ? params[:id] : "/#{params[:path]}")
      # TODO: more exploration is needed around caching. Some server-side caching as well, for instance
      expires_in(@page.cache_length.to_i.seconds)
      if stale?(@page)
        respond_with @page do |format|
          format.html {
            render_smithy_page
          }
        end
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

    def order
      first = Smithy::Page.find(params[:order].shift)
      @parent = first.parent
      return unless @parent && @parent.children.count > 1 # Only need to order if there are multiple children.
      left = first.id
      params[:order].each do |page_id|
        page = Smithy::Page.find(page_id)
        page.move_to_right_of(left)
        left = page.id
      end
      if request.xhr?
        render :nothing => true, :status => 200
      else
        redirect_to pages_path
      end
    end

    private
      def initialize_page
        @page = Page.new(params[:page])
        set_publish
      end

      def load_page
        @page = Page.find(params[:id])
        @root = @page if Page.root == @page
        set_publish
      end

      def load_parent
        @parent = @page.parent
      end

      def load_root
        @root = Page.root
      end

      def set_publish
        @page.publish = true if params[:publish].present?
        @page.publish = false if params[:draft].present?
      end

  end
end
