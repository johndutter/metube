class SessionController < ApplicationController
  #check if user is logged in before allowing them to log in
  
  def login
  end
  
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
    respond_to do |format|
      format.json{head :accepted}
    end
  end
  
  private
  def login_params
    params.require(:login).permit(:username, :password)
  end
  
end