class Admin::ThemesController < Admin::AdminController
  def index
    @themes = Theme.all
    logger.debug("themes #{@themes.inspect}")
    @active = @themes.find{|t| t.active }
  end

  def activate
    theme = params[:theme]
    if theme and (theme=Theme.find_by_name(theme))
      theme.activate!
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
