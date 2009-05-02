class Admin::AdminController < ApplicationController
  helper Admin::UiHelper
  before_filter :require_admin_user, :setup_bloginfo

  def require_admin_user
    unless current_user # and current_user.is_admin?
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_admin_user_session_url
      return false
    end
  end

  def setup_bloginfo
    general = Option.find_by_key('site_info')
    @blog_info = Option.default_general_object
    return if general.nil?
    @blog_info = OpenStruct.new(ActiveSupport::JSON.decode(general.value))
  end
end
