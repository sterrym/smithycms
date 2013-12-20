require_dependency "smithy/base_controller"

module Smithy
  class SitemapController < BaseController
    respond_to :xml
    skip_before_filter :authenticate_smithy_admin

    def show
      @pages = Smithy::Page.root.self_and_descendants
      respond_with @pages
    end
  end
end
