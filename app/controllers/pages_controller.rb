class PagesController < ApplicationController
  before_filter :load_site_info

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
    @site_info = Option.load_by_key('site_info')
  end
end
