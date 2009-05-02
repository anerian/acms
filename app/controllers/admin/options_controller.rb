class Admin::OptionsController < Admin::AdminController
  def index
  end

  def general
    # fetch general options
    @general = Option.find_by_key('site_info')
    if @general.nil?
      @general = Option.new
      @general.key = 'site_info'
      @values = @general.value = {}
    else
      @values = ActiveSupport::JSON.decode(@general.value)
    end
    if request.post?
      # save
      params[:option].each do|key,value|
        @values[key] = value
      end
      @general.value = @values.to_json
      if @general.save
        flash[:success] = "Saved"
        redirect_to general_admin_options_path
      end
    end
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
