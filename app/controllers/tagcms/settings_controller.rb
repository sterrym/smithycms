require_dependency "tagcms/application_controller"

module Tagcms
  class SettingsController < ApplicationController
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
      @setting = Setting.new(params[:setting])
      respond_with @setting
    end

    def create
      @setting = Setting.new(params[:setting])
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
      flash.notice "Your setting was saved" if @setting.update_attributes(params[:setting])
      respond_with @setting
    end

    def destroy
      @setting = Setting.find(params[:id])
      @tempalte.destroy
      respond_with @setting
    end
  end
end
