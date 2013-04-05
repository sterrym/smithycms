require_dependency "smithy/base_controller"

module Smithy
  class GuidesController < BaseController
    def show
      render :action => params[:id], :layout => request.xhr? ? false : 'smithy/guides'
    end
  end
end
