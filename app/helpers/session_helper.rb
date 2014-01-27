module SessionHelper
  
  #don't allow logged in user to access log in page
  def check_login
    if session[:user_id]
      respond_to do |format| 
        format.json {head :ok}
      end
    else
      respond_to do |format|
        format.json{head :unauthorized}
      end
    end
  end
  
  def authenticate_user
    if session[:user_id]
       # set current user object to @current_user object variable
      user = User.find session[:user_id] 
      #check if user is authenticated to perform restricted action
    end
  end
  
end
