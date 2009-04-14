class Admin::OptionsController < Admin::AdminController
  def index
  end

  class GeneralOptions
    KeyTypes = {:blog_title => :string,
                :tagline => :string,
                :blog_url => :string,
                :blog_email => :string,
                :timezone => :string,
                :date_format => :string,
                :time_format => :string,
                :weekstart => :string}.freeze
    Keys = KeyTypes.keys.freeze #%w(blog_title tagline blogurl admin_email timezone date_format time_format weekstart).freeze
  end

  def general
    # fetch general options
    @option_values = Option.find(:all, :conditions => {:key => GeneralOptions::Keys})
    # map keys to values
    @options = {}
    GeneralOptions::Keys.each {|k| @options[k] = nil }
    @option_values.each {|v| @options[v.key] = v }
    if request.post?
      # save
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
