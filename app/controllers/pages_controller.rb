class PagesController < ApplicationController

  def index
  end

  def show
    # lookup the page for this request
    @page = Page.find_by_id(params[:id])
    @site_info = Option.load_by_key('site_info')
    if @page
      render :layout => 'default'
    else
      @page = params[:page]
      @page = 1 if @page.blank?
      @pages = Page.paginate(:all, {:page => @page})
      render :action => 'index', :layout => 'default'
    end
  end

end
