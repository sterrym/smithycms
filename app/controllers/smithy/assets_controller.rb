require_dependency "smithy/base_controller"

module Smithy
  class AssetsController < BaseController
    skip_before_filter :authenticate_smithy_admin, :only => [ :url ]
    before_filter :load_assets, :only => :index
    respond_to :html, :json, :js

    def index
      @asset_source = AssetSource.first
      respond_with @assets, :layout => 'smithy/wide' do |format|
        format.html
        format.json { render json: ::Smithy::AssetsDatatable.new(view_context, params[:type]) }
      end
    end

    def show
      @asset = Asset.find(params[:id])
      respond_with @asset do |format|
        format.html { redirect_to @asset.url }
      end
    end

    def new
      @asset = Asset.new(filtered_params)
      respond_with @asset
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

    def selector_modal
      respond_to do |format|
        format.html { render :layout => 'smithy/modal' }
      end
    end

    def batch_destroy
      @assets = Asset.where(id: params[:ids])
      @assets.destroy_all
      respond_with @assets do |format|
        format.js { render json: { ids: params[:ids] }, callback: "assets_table_delete_rows" }
      end
    end

    def data
      @asset = Asset.find(params[:id])
      send_data @asset.data, filename: @asset.file_filename, disposition: "inline", type: ::File.extname(@asset.file_filename).downcase.sub(/^\./, '').to_sym
    end

    private
      def load_assets
        @assets = Asset.order(:name).page(params[:page])
      end
  end
end
