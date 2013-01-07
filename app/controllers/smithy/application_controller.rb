class Smithy::ApplicationController < ApplicationController
  before_filter :authenticate_smithy_admin

  private

    def authenticate_smithy_admin
      if !smithy_user || !smithy_user.smithy_admin?
        flash.alert = "You are not allowed to do that."
        redirect_to "/" #TODO: not positive where to redirect here
      end
    end
end
