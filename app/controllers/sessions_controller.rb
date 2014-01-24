class SessionsController < ApplicationController
  def login
  end
  
  def try_login
    logger.info "Inside try_login\n"
    user = User.authenticate(login_params[:username], login_params[:password])
    if user
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
end
