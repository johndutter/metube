class SessionsController < ApplicationController
  #check if user is logged in before allowing them to log in
  before_action :check_login_state, :only => [:login, :try_login]
  
  def login
  end
  
  def try_login
    logger.info "Inside try_login\n"
    user = User.authenticate(login_params[:username], login_params[:password])
    if user
      session[:user_id] = user[:id]
      flash[:notice] = "Welcome #{user.username}"
      redirect_to(:action => 'home')
    else
      flash[:notice] = "Invalid Username or Password"
      flash[:color]= "invalid"
      
      #rerender the login page
      render "login"	
    end
  end

  def home
  end

  def profile
  end

  def setting
  end
  
  private
  def login_params
    params.require(:login).permit(:username, :password)
  end
  
  #don't allow logged in user to access log in page
  def check_login_state
    if session[:user_id]
      redirect_to(:controller => 'sessions', :action => 'home')
    end
  end
end
