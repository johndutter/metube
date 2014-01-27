class SessionController < ApplicationController
  #check if user is logged in before allowing them to log in
  before_action :check_login_state, :only => [:login]
  
  def login
  end
  
  def try_login
    logger.info 'Inside try_login'
    logger.info "PARAMTERS:  #{params[:password]}"
    user = User.authenticate(params[:username], params[:password])
    if user
      session[:user_id] = user[:id]
      render :json => user.username
      #for testing purposes
      #render 'home'
    else
      respond_to do |format|
        format.json {header :not_found}
      end
    end
    logger.info 'leaving'
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
