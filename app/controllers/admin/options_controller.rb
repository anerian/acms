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

  def media
    # fetch media options
    @media = Option.find_by_key('media_info')
    if @media.nil?
      @media = Option.new
      @media.key = 'media_info'
      @values = @media.value = {}
    else
      @values = ActiveSupport::JSON.decode(@media.value)
    end
    if request.post?
      # save
      params[:option].each do|key,value|
        @values[key] = value
      end
      @media.value = @values.to_json
      if @media.save
        flash[:success] = "Saved"
        redirect_to media_admin_options_path
      end
    end
  end

  def writing
    # fetch writing options
    @writing = Option.find_by_key('writing')
    if @writing.nil?
      @writing = Option.new
      @writing.key = 'writing'
      @values = @writing.value = {}
    else
      @values = ActiveSupport::JSON.decode(@writing.value)
    end
    if request.post?
      # save
      params[:option].each do|key,value|
        @values[key] = value
      end
      @writing.value = @values.to_json
      if @writing.save
        flash[:success] = "Saved"
        redirect_to writing_admin_options_path
      end
    end
  end

  def reading
    # fetch media options
    @reading = Option.find_by_key('reading')
    if @reading.nil?
      @reading = Option.new
      @reading.key = 'reading'
      @values = @reading.value = {}
    else
      @values = ActiveSupport::JSON.decode(@reading.value)
    end
    if request.post?
      # save
      params[:option].each do|key,value|
        @values[key] = value
      end
      @reading.value = @values.to_json
      if @reading.save
        flash[:success] = "Saved"
        redirect_to reading_admin_options_path
      end
    end
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
