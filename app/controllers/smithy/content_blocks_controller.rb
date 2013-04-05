require_dependency "smithy/application_controller"

module Smithy
  class ContentBlocksController < BaseController
    before_filter :load_content_blocks
    respond_to :html, :json

    def index
      respond_with @content_blocks
    end

    def new
      @content_block = ContentBlock.new(params[:content_block])
      respond_with @content_block
    end

    def create
      @content_block = ContentBlock.new(params[:content_block])
      @content_block.save
      flash.notice = "Your content_block was created" if @content_block.persisted?
      respond_with @content_block do |format|
        format.html { redirect_to [:edit, @content_block] }
      end
    end

    def edit
      @content_block = ContentBlock.find(params[:id])
      respond_with @content_block
    end

    def update
      @content_block = ContentBlock.find(params[:id])
      flash.notice = "Your content_block was saved" if @content_block.update_attributes(params[:content_block])
      respond_with @content_block do |format|
        format.html { redirect_to [:edit, @content_block] }
      end
    end

    def destroy
      @content_block = ContentBlock.find(params[:id])
      @content_block.destroy
      respond_with @content_block
    end

    private
      def load_content_blocks
        @content_blocks = ContentBlock.all
      end
  end
end
