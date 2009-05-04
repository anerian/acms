class Admin::PagesController < Admin::AdminController
  def index
    @page = params[:page]
    @page = 1 if @page.blank?
    @pages = Page.paginate(:all, {:page => @page })
  end

  def show
    @page = Page.find_by_id(params[:id])
  end

  def new
    @page = Page.new
  end

  def create
    @page = current_user.pages.new(params[:page])
    if @page.save
      respond_to do |t|
        t.html {flash[:success] = t(:page_created); redirect_to edit_admin_page_path(@page) }
        t.js { render :text => t(:page_created) }
      end
    else
      respond_to do |t|
        t.html { flash.now[:error] = t(:page_errors); render :action => 'new' }
        t.js { render :status => 500, :text => t(:page_errors) }
      end
    end
  end

  def edit
    @page = Page.find_by_id(params[:id], :include => {:categories => [:children]})
  end

  def update
    @page = Page.find_by_id(params[:id])
    if @page.update_attributes(params[:page])
      respond_to do|t|
        t.html {flash[:success] = t(:page_created); redirect_to edit_admin_page_path(@page) }
        t.js { render :text => t(:page_created) }
      end
    else
      respond_to do|t|
        t.html { flash.now[:error] = t(:page_errors); render :action => 'new' }
        t.js { render :status => 500, :text => t(:page_errors) }
      end
    end
  end

  def delete
  end

  def destroy
  end

end
