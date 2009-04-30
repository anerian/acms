class UserSessionsController < ApplicationController
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    if !email.blank? and email.match(/^.*@anerian\.com$/)
      email    = params[:user_session][:email]
      password = params[:user_session][:password]
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

        unless @user_session = UserSession.create(params[:user_session])
          # should never get here -- if we do, looks like something went wrong with creating the user and authenticating it above
          flash[:error] = "There was a problem with your authentication. Please try again, or contact support if you still can't login."
          render :action => :new
        end
      rescue Google::LoginError
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
