require_dependency "smithy/base_controller"

module Smithy
  class AssetsController < BaseController
    skip_before_filter :authenticate_smithy_admin, :only => [ :url ]
    before_filter :load_assets, :only => :index
    respond_to :html, :json, :js

    def index
      respond_with @assets, :layout => 'smithy/wide' do |format|
        format.html
        format.json { render json: ::Smithy::AssetsDatatable.new(view_context) }
      end
    end

    def new
      @asset = Asset.new(filtered_params)
      respond_with @asset
    end

    def create
      @asset = Asset.new(filtered_params)
      @asset.save
      respond_with @asset do |format|
        format.html {
          flash.notice = "Your asset was created" if @asset.persisted?
          redirect_to assets_path
        }
        format.js { render json: ::Smithy::AssetsDatatable.new(view_context).new_row(@asset), callback: 'assets_table_add_row' }
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

    def delete_selected
      @assets = Asset.where(id: params[:ids])
      @assets.destroy_all
      respond_with @assets do |format|
        format.js { render json: { ids: params[:ids] }, callback: "assets_table_delete_rows" }
      end
    end

    def presigned_fields
      count = params[:count].to_i if params[:count].present?
      count ||= 1
      @assets = count.times.map{ Asset.new }
      respond_to do |format|
        format.js
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
