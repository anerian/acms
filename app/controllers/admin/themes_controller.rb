class Admin::ThemesController < Admin::AdminController
  def index
    @themes = Dir["#{THEME_ROOT}/*"].reject{|t| File.basename(t) == 'active' }.map{|t| [File.basename(t),t]}
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
