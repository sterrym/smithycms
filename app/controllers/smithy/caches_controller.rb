require_dependency "smithy/application_controller"

module Smithy
  class CachesController < BaseController
    def show
    end

    def destroy
      Rails.cache.clear
      redirect_to cache_path, :notice => "The cache has been cleared"
    end
  end
end
