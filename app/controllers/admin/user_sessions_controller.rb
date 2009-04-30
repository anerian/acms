class Admin::UserSessionsController < Admin::AdminController
  before_filter :require_admin_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    email    = params[:user_session][:email]
    password = params[:user_session][:password]
    if !email.blank? and email.match(/^.*@anerian\.com$/)
      begin
        Google::Base.establish_connection(email,password)

        # if we're here above line succeeded and we have a valid anerian google user
        unless User.find_by_email(email)
          # user doesn't have an account yet, create them one
          user = User.create( :email => email,
                              :name  => email.gsub(/@anerian\.com/,'').gsub(/\./,' ').titleize,
                              :google => true,
                              :password => password,
                              :password_confirmation => password )
        end

        if @user_session = UserSession.create(params[:user_session])
          flash[:notice] = "Login successful!"
          redirect_back_or_default '/admin'
        else
          flash[:error] = "There was a problem with your authentication. Please try again, or contact support if you still can't login."
          render :action => :new
        end
      rescue Google::LoginError => e
        @user_session = UserSession.new(params[:user_session])
        flash[:error] = "Your Google login attempt failed: #{e.message}"
        render :action => :new
      end
    else
      @user_session = UserSession.new(params[:user_session])
      if @user_session.save
        flash[:notice] = "Login successful!"
        redirect_back_or_default account_url
      else
        render :action => :new
      end
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end
end
