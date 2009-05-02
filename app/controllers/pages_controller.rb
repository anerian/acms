class PagesController < ApplicationController

  def index
  end

  def show
    # lookup the page for this request
    @page = Page.find_by_id(params[:id])
    @site_info = OpenStruct.new(ActiveSupport::JSON.decode(Option.find_by_key("blog_info").value)) rescue {}
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
