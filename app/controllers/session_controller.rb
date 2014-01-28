class SessionController < ApplicationController
  #check if user is logged in before allowing them to log in

  #before_action :check_login, :only => [:login]

  def login
    user = User.authenticate(params[:username], params[:password])
    if user
      session[:user_id] = user[:id]
      render :json => { success: true, user: user.username }
    else
      render :json => { success: false, user: '' }
    end
  end
  
  def logout
    session[:user_id] = nil
    render :json => { success: true }
  end

  def loggedin
    if session[:user_id].nil?
      render :json => '0'
    else
      render :json => session[:user_id]
    end
  end
  
  private
  def login_params
    params.require(:login).permit(:username, :password)
  end
  
end
