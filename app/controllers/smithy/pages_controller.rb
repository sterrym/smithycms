require_dependency "smithy/base_controller"

module Smithy
  class PagesController < BaseController
    skip_before_filter :authenticate_smithy_admin, :only => [ :show ]
    include Smithy::Liquid::Rendering
    before_filter :load_page_from_path, :only => [ :show ]
    before_filter :initialize_page, :only => [ :new, :create ]
    before_filter :load_page, :only => [ :edit, :update, :destroy, :duplicate ]
    before_filter :load_parent, :except => [ :index, :show, :order, :selector_modal ]
    before_filter :load_root, :only => [ :index ]
    respond_to :html, :json

    def index
      respond_with @root
    end

    def show
      render_page and return if smithy_current_user # no caching if you're editing
      # adding :public param allow Rack::Cache to cache the result
      @page.cache_length == 0 ? expires_now : expires_in(@page.cache_length.to_i.seconds, :public => true)
      render_page if stale?(:etag => @page, :last_modified => @page.updated_at.utc, :public => true)
    end

    def new
      respond_with @page
    end

    def create
      @page.duplicate_content_from(params[:page][:copy_content_from]) if params[:page][:copy_content_from].present? && @page.valid?
      @page.save
      flash.notice = "Your page was created #{@page.published? ? 'and published' : 'as a draft'}" if @page.persisted?
      respond_with @page do |format|
        format.html { @page.persisted? ? redirect_to(edit_page_path(@page.id)) : render(:action => 'new') }
      end
    end

    def edit
      respond_with @page
    end

    def update
      flash.notice = "Your page was saved #{@page.published? ? 'and published' : 'as a draft'}" if @page.update_attributes(filtered_params)
      respond_with @page do |format|
        format.html { redirect_to edit_page_path(@page.id) }
      end
    end

    def destroy
      @page.destroy
      respond_with @page.parent ? @page.parent : @page
    end

    def duplicate
      old_page = @page
      @page = @page.shallow_copy
      @page.copy_content_from = old_page.id
      respond_with @page do |format|
        format.html { render(action: :new) }
      end
    end

    def order
      first = Smithy::Page.find(params[:order].shift)
      @parent = first.parent
      if @parent && @parent.children.count > 1 # Only need to order if there are multiple children.
        left = first.id
        params[:order].each do |page_id|
          page = Smithy::Page.find(page_id)
          page.move_to_right_of(left)
          left = page.id
        end
      end
      render :nothing => true, :status => 200 and return if request.xhr?
      redirect_to pages_path
    end

    def selector_modal
      respond_to do |format|
        format.html { render :layout => 'smithy/modal' }
      end
    end

    private
      def initialize_page
        @page = Page.new(filtered_params)
        set_publish
      end

      def load_page
        @page = Page.includes(contents: [:content_block_template]).find(params[:id])
        @root = @page if Page.root == @page
        set_publish
      end

      def load_page_from_path
        if smithy_current_user
          @page = Page.includes(:contents).friendly.find(page_path)
        else
          @page = Page.includes(:contents).published.friendly.find(page_path)
        end
        redirect_to @page.external_link and return false if @page.external_link?
      end

      def load_parent
        @parent = @page.parent
      end

      def load_root
        @root = Page.root
      end

      def page_path
        params[:path] = '' if params[:id].nil? && params[:path].nil? # sets the root path when nothing else is passed
        params[:path].nil? ? params[:id] : "/#{params[:path]}"
      end

      def render_page
        respond_with @page do |format|
          format.html { render_smithy_page }
        end
      end

      def set_publish
        @page.publish = true if params[:publish].present?
        @page.publish = false if params[:draft].present?
      end

  end
end
