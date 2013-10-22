class Smithy::BaseController < ApplicationController
  layout 'smithy/application'

  before_filter :authenticate_smithy_admin

  private

    def authenticate_smithy_admin
      unless smithy_current_user && smithy_current_user.smithy_admin?
        flash.alert = "Please login to continue."
        redirect_to smithy_login_path
      end
    end
end
