class Admin::PagesController < Admin::AdminController
  def index
  end

  def show
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(params[:page])
    if @page.save
      flash[:success] = t(:page_created)
      redirect_to edit_admin_page_path(@page)
    else
      flash.now[:error] = t(:page_errors)
      render :action => 'new'
    end
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
