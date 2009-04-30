class PagesController < ApplicationController

  def index
  end

  def show
    # lookup the page for this request
    @page = Page.find_by_id(params[:id])
    if @page
      render :layout => 'default'
    else
    end
  end

end
