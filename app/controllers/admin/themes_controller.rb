class Admin::ThemesController < Admin::AdminController
  def index
    @themes = Theme.all
    @active = @themes.find{|t| t[:active] }
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
