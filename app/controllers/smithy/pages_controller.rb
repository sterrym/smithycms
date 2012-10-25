require_dependency "smithy/application_controller"

module Smithy
  class PagesController < ApplicationController
    before_filter :initialize_page, :only => [ :new, :create ]
    before_filter :load_page, :only => [ :show, :edit, :update, :destroy ]
    before_filter :load_parent, :except => [ :index ]
    before_filter :load_root, :only => [ :index ]
    respond_to :html, :json

    def index
      respond_with @root
    end

    def show
      respond_with @page do |format|
        format.html { render :text => @page.render, :layout => false }
      end
    end

    def new
      respond_with @page
    end

    def create
      @page.save
      flash.notice = "Your page was created" if @page.persisted?
      respond_with do |format|
        format.html { edit_page_path(@page.id) }
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
  end
end
