require_dependency "smithy/base_controller"

module Smithy
  class ContentsController < BaseController
    respond_to :html, :json

    def show
      @content = Smithy::Content.find(params[:id])
      respond_with @content
    end

    def new
      @content = Smithy::Content.new(params[:content])
      respond_with @content
    end

    def create
      @content = Smithy::Content.new(params[:content])
      @content.save
      flash.notice = "Your content was created" if @content.persisted?
      respond_with @content
    end

    def edit
      @content = Smithy::Content.find(params[:id])
      respond_with @content
    end

    def update
      @content = Smithy::Content.find(params[:id])
      flash.notice = "Your content was saved" if @content.update_attributes(params[:content])
      respond_with @content
    end

    def destroy
      @content = Smithy::Content.find(params[:id])
      @content.destroy
      respond_with @content
    end
  end
end
