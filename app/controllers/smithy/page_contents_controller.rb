require_dependency "smithy/application_controller"

module Smithy
  class PageContentsController < ApplicationController
    before_filter :load_content_blocks, :only => [ :new, :create ]
    respond_to :html, :json

    def new
      @page_content = Smithy::PageContent.new(params[:page_content])
    end

    def create
      @page_content = Smithy::PageContent.new(params[:page_content])
      @page_content.save
      flash.notice = "Your content was created" if @page_content.persisted?
      respond_with @page_content
    end

    private
      def load_content_blocks
        @content_blocks = ContentBlock.all
      end

  end
end
