require_dependency "smithy/base_controller"

module Smithy
  class SettingsController < BaseController
    respond_to :html, :json

    def index
      @settings = Setting.all
      respond_with @settings
    end

    def show
      @setting = Setting.find(params[:id])
      respond_with @setting
    end

    def new
      @setting = Setting.new(filtered_params)
      respond_with @setting
    end

    def create
      @setting = Setting.new(filtered_params)
      @setting.save
      flash.notice = "Your setting was created" if @setting.persisted?
      respond_with @setting
    end

    def edit
      @setting = Setting.find(params[:id])
      respond_with @setting
    end

    def update
      @setting = Setting.find(params[:id])
      flash.notice = "Your setting was saved" if @setting.update_attributes(filtered_params)
      respond_with @setting
    end

    def destroy
      @setting = Setting.find(params[:id])
      @setting.destroy
      respond_with @setting
    end
  end
end
