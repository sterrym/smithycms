require_dependency "smithy/base_controller"

module Smithy
  class AssetSourcesController < BaseController
    respond_to :html, :json, :js

    def update
      @asset_source = AssetSource.find(params[:id])
      if @asset_source.update_attributes(filtered_params)
        flash.notice = "Your assets were saved"
        @assets = @asset_source.assets
      end
      respond_with @asset_source do |format|
        format.js { render json: AssetsDatatable.new(view_context).new_row(@assets), callback: 'assets_table_add_rows' }
      end
    end

    def presigned_upload_field
      @asset_source = AssetSource.find(params[:id])
      respond_to do |format|
        format.js
      end
    end
  end
end
