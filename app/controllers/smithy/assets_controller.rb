require_dependency "smithy/base_controller"

module Smithy
  class AssetsController < BaseController
    before_filter :load_assets, :only => :index
    respond_to :html, :json, :js

    def index
      respond_with @assets, :layout => 'smithy/wide'
    end

    def new
      @asset = Asset.new(filtered_params)
      respond_with @asset
    end

    def create
      @asset = Asset.new(filtered_params)
      @asset.save
      flash.notice = "Your asset was created" if @asset.persisted?
      respond_with @asset do |format|
        format.html { redirect_to assets_path }
      end
    end

    def edit
      @asset = Asset.find(params[:id])
      respond_with @asset
    end

    def update
      @asset = Asset.find(params[:id])
      flash.notice = "Your asset was saved" if @asset.update_attributes(filtered_params)
      respond_with @asset do |format|
        format.html { redirect_to assets_path }
      end
    end

    def destroy
      @asset = Asset.find(params[:id])
      @asset.destroy
      respond_with @asset
    end

    private
      def load_assets
        @assets = Asset.order(:name).page(params[:page])
      end
  end
end
