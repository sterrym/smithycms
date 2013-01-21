module Smithy
  class GuidesController < ApplicationController
    def show
      render :action => params[:id], :layout => request.xhr? ? false : 'smithy/guides'
    end
  end
end
