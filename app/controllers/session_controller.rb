class SessionController < ApplicationController
  #check if user is logged in before allowing them to log in

  #before_action :check_login, :only => [:login]

  def login
    user = User.authenticate(params[:username], params[:password])
    if user
      session[:user_id] = user[:id]
      render :json => { user: user.username }
    else
      render :json => { user: '' }
    end
  end
  
  def logout
    session[:user_id] = nil
    head :ok
  end
  
  def testApi
    render :json => {test: 'word'};
  end
  
  private
  def login_params
    params.require(:login).permit(:username, :password)
  end
  
end
