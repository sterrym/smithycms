class ApplicationController < ActionController::Base
  protect_from_forgery

  def smithy_user
    current_user
  end
  helper_method :smithy_user

  def sign_in_path
    new_user_session_path
  end
end
