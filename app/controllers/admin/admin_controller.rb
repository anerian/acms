class Admin::AdminController < ApplicationController
  before_filter :require_admin_user

  def require_admin_user
    unless current_user # and current_user.is_admin?
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_admin_user_session_url
      return false
    end
  end
end
