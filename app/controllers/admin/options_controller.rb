class Admin::OptionsController < Admin::AdminController
  def index
    # view all global options and your personalized options
    @opts = Option.find(:all, :conditions => ["user_id IS NULL OR user_id=?", @auth_user.id])
  end

  def writing
  end

  def reading
  end

  def show
    @opt = Option.find_by_id(id)
  end

  def new
    @opt = Option.new
  end

  def create
    @opt = Option.new(params[:option])
    if opt.save
      respond_to do|t|
        t.html{ redirect_to admin_options_path }
        t.js{ render :text => 'saved' }
      end
    else
      respond_to do|t|
        t.html{ render :action => 'new' }
        t.js{ render :text => 'saved' }
      end
    end
  end

  def edit
    @opt = Option.find_by_id(id)
  end

  def update
    @opt = Option.find_by_id(id)
    if opt.update_attributes(params[:option])
      respond_to do|t|
        t.html{ redirect_to admin_options_path }
        t.js{ render :text => 'saved' }
      end
    else
      respond_to do|t|
        t.html{ render :action => 'edit' }
        t.js{ render :text => 'saved' }
      end
    end
  end

  def delete
    @opt = Option.find_by_id(id)
  end

  def destroy
    @opt = Option.find_by_id(id)
  end

end
