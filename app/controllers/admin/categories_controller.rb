class Admin::CategoriesController < Admin::AdminController
  def index
  end

  def show
  end

  def new
  end

  def create
    @category = Category.create(params[:category])
    
    respond_to do |format|
      format.html
      format.js
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
