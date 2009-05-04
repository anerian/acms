class PagesController < ApplicationController
  before_filter :load_site_info
  around_filter :preview_filter

  def index
    @page = params[:page]
    @page = 1 if @page.blank?
    @pages = Page.paginate(:all, {:page => @page})
    render :layout => 'default'
  end

  def show
    if params[:id]
      @page = Page.find_by_id(params[:id])
      render :layout => 'default'
    else
      render :action => 'index', :layout => 'default'
    end
  end

protected
  def load_site_info
    @theme_path = THEME_PATH
  end

  def preview_filter
    if params[:preview]
      # check user is admin and logged in
      unless current_user # and current_user.is_admin?
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_admin_user_session_url
        return false
      end

      # lookup requested theme
      @preview_theme = Theme.find_by_name(params[:preview])

      @theme_path = @preview_theme[:path]

      THEME_PREVIEW_MUTEX.synchronize do # XXX: view_paths is not request scoped must lock
        # add preview theme to the front of view path
        @tmp_view_paths = ActionController::Base.view_paths.map{|v| v} # deep copy...
        paths = ActionView::PathSet.new([File.join(@preview_theme[:path],'views')] + @tmp_view_paths)
        ActionController::Base.view_paths = paths
        self.view_paths = paths
        view_paths.load!
        logger.debug "using view path: #{ActionController::Base.view_paths.inspect} and #{view_paths.inspect}"
        yield
        # remove preview theme from view path
        paths = ActionView::PathSet.new(@tmp_view_paths)
        ActionController::Base.view_paths = paths
        self.view_paths = paths
        logger.debug "restored view path: #{ActionController::Base.view_paths.inspect} and #{view_paths.inspect}"
      end

    else
      yield
    end

  end

end
