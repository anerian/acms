class Admin::AssetsController < Admin::AdminController
  before_filter :load_media_options

  def index
  end

  def show
  end

  def new
  end

  def create
    @asset = Asset.new(params[:asset])
    if @asset.save
      render :text => "asset saved"
    else
      render :text => @asset.to_json
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

protected
  def load_media_options
    @media_info = Option.load_by_key('media_info')
    if @media_info.nil? or @media_info.site_key.nil? or @media_info.site_secret.nil?
      flash[:notice] = "To upload files you must first add the site configuration"
      redirect_to media_admin_options_path
    end
  end
end
