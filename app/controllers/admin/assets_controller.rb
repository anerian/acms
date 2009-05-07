class Admin::AssetsController < Admin::AdminController
  protect_from_forgery :except => [:upload_sign]
  before_filter :load_media_options
  before_filter :ensure_user, :only => [:create, :update]

  def upload_sign
    begin
      # parse the referer this can fail if it's malformed
      referer = URI.parse(params["referer"])
    rescue => e
      return [500, {'Content-Type' => 'text/plain'}, e.message]
    end

    # build the referer protocol + host and port if it's not 80
    referer_url = referer.scheme + '://' + referer.host
    referer_url += ':' + referer.port.to_s if referer.port != 80

    # sign request
    signature = Base64.encode64(OpenSSL::Digest::SHA1.hexdigest($upid + referer_url + $upkey + request.query_string)).strip


    # service url
    url = 'http://' + $uphost + "/api/s/#{$upid}?" + request.query_string

    # send a curl POST request including the signature as the POST body.
    c = Curl::Easy.http_post(url, Curl::PostField.content('signature', signature))

    # parse the response headers into a hash
    hdrs = c.header_str.split("\r\n")
    status_line = hdrs.shift
    headers = {}
    hdrs.each do|line|
      key, value = line.split(':')
      headers[key] = value
    end

    # respond with the same response received from the service. effectively proxying the request
    response.headers['ETag'] = headers['ETag']
    render :status => c.response_code, :text => c.body_str #, headers, c.body_str]
  end

  def picker
    @page = params[:page]
    @page ||= 1
    @basic_type = params[:basic_type]
    conditions = @basic_type.blank?? {} : {:basic_type => @basic_type}
    @assets = Asset.paginate :page => @page, :conditions => conditions
  end

  def index
    @page = params[:page]
    @page ||= 1
    @basic_type = params[:basic_type]
    conditions = @basic_type.blank?? {} : {:basic_type => @basic_type}
    @assets = Asset.paginate :page => @page, :conditions => conditions, :order => 'created_at DESC', :include => :user
  end

  def list
    from = params[:from].to_i
    to = params[:to].to_i

    if from >= to
      render :content_type => 'text/json', :text => "{'error':'invalid range'}" and return
    end

    from -= 1 if from > 1
    limit = (from - to).abs

    keyword = params[:keyword] # user keyword to filter results by filename, description, or tags
    basic_type_filter = params[:filter] # placement filter, 'image', 'flash', 'doc', etc... set in the UI explicity

    filter_options = {}

    filter_options = {:conditions => {:basic_type => basic_type_filter}} if basic_type_filter

    if keyword.blank?
      total = Asset.count(filter_options)
      assets = Asset.find(:all, filter_options.merge(:limit => limit, :offset => from, :order => 'updated_at DESC'))
    else
      filterby = "%#{keyword}%"
      if basic_type_filter
        conditions = ["basic_type=? and filename LIKE ? or description LIKE ? or cached_tag_list LIKE ?",
                       basic_type_filter, filterby, filterby, filterby]
      else
        conditions = ["filename LIKE ? or description LIKE ? or cached_tag_list LIKE ?",
                       filterby, filterby, filterby]
      end
      total = Asset.count(:conditions => conditions )
      assets = Asset.find(:all, :conditions => conditions, :order => 'updated_at DESC', :limit => limit, :offset => from)
    end

    @limit = limit
    @from  = from
    @to = to
    @total = total
    @assets = assets

    render :content_type => 'text/json'
  end

  def show
    @asset = Asset.find_by_id(params[:id])
    respond_to do|type|
      type.html {  }
      type.js { render :text => @asset.to_json(:methods => [:public_filename, :public_filename_thumb], :only => [:public_filename_thumb, :public_filename, :content_type, :basic_type, :id]),
                       :content_type => "text/js" }
    end
  end

  def create
    @asset = Asset.new(params[:asset])
    if @asset.save
      flash[:success] = "#{Asset} saved!"
      respond_to do|t|
        t.html { redirect_to edit_admin_asset_path(@asset) }
        t.js { render :layout => false, :text => edit_admin_asset_path(@asset) }
      end
    else
      respond_to do|t|
        t.html {
          flash.now[:error] = "Error creating Asset!"
          render :action => 'new'
        }
        t.js {
          render :layout => false, :text => "Error creating Asset!"
        }
      end
    end
  end

  # TODO - need to convert these to not use lib/resourceful
  def on_update_before
    logger.debug("\t\tAsset: #{@asset.inspect},\n\t\tvalid: #{@asset.valid?}\n\t\t#{@asset.errors.inspect}")
    if params[:asset][:content_type].blank?
      # updating without changing the image
      params[:asset].merge!(
        :filename => @asset.filename,
        :content_type => @asset.content_type,
        :basic_type => @asset.basic_type,
        :remote => @asset.remote,
        :size => @asset.size,
        :thumbnail => @asset.thumbnail,
        :width => @asset.width,
        :height => @asset.height)
    end
    return false
  end

  def on_index_paginate(options)
    if params[:filter]
      f = "%#{params[:filter]}%"
      options[:conditions] = ["filename LIKE ? or description LIKE ? or cached_tag_list LIKE ? ", f, f, f ]
    end
    options
  end

  def on_destroy_before
    if !params[:confirm]
      flash[:notice] = "File not destroyed you did not confirm the deletion of #{@asset.filename}"
      redirect_to delete_admin_asset_path(@asset)
      return true
    end
    return false
  end

protected
  
  def ensure_user
    #params[:asset].merge!(:user_id => current_user.id)
  end

  def load_media_options
    @media_info = Option.load_by_key('media_info')
    if @media_info.nil? or @media_info.site_key.nil? or @media_info.site_secret.nil?
      flash[:notice] = "To upload files you must first add the site configuration"
      redirect_to media_admin_options_path
    end
  end
end
