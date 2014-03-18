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

    def filtered_params
      permitted_params.params_for controller_name.singularize
    end

    def permitted_params
      permitted_params ||= PermittedParams.new(params, smithy_current_user)
    end
    helper_method :permitted_params
end
