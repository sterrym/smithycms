require_dependency "smithy/base_controller"

module Smithy
  class ImagesController < BaseController
    respond_to :html, :json

    def show
      @image = Smithy::Image.find(params[:id])
      respond_with @image
    end

    def new
      @image = Smithy::Image.new(params[:image])
      respond_with @image
    end

    def create
      @image = Smithy::Image.new(params[:image])
      @image.save
      flash.notice = "Your image was created" if @image.persisted?
      respond_with @image
    end

    def edit
      @image = Smithy::Image.find(params[:id])
      respond_with @image
    end

    def update
      @image = Smithy::Image.find(params[:id])
      flash.notice = "Your image was saved" if @image.update_attributes(params[:image])
      respond_with @image
    end

    def destroy
      @image = Smithy::Image.find(params[:id])
      @image.destroy
      respond_with @image
    end
  end
end
