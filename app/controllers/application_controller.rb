class ApplicationController < ActionController::Base

  include ApplicationHelper

  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authenticate!
    if @user = current_user
      redirect_to confirm_email_account_path if !@user.is_email_confirmed
    else
      redirect_to login_account_path
    end
  end

  def authenticate_as_admin!
    if current_user
      page_403 if !current_user.is_admin
    else
      redirect_to login_account_path
    end
  end

end
