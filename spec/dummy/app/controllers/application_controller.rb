class ApplicationController < ActionController::Base
  protect_from_forgery

  def smithy_current_user
    current_user
  end
  helper_method :smithy_current_user
end
