class Admin::ThemesController < Admin::AdminController
  def index
    @themes = Theme.all
    logger.debug("themes #{@themes.inspect}")
    @active = @themes.find{|t| t.active }
  end

  def activate
    theme = params[:theme]
    if theme and (theme=Theme.find_by_name(theme))
      THEME_PREVIEW_MUTEX.synchronize do # XXX: view_paths is not request scoped must lock
        theme.activate!
        ActionController::Base.view_paths.shift
        paths = ActionView::PathSet.new([File.join(theme.path,'views')] + ActionController::Base.view_paths )
        ActionController::Base.view_paths = paths
        view_paths = paths
      end
      render :status => 200, :text => "activated" and return
    end
  end

  def widgets
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def delete
  end

  def destroy
  end

end
