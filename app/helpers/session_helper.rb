module SessionHelper
  
  def authenticate_user
    if session[:user_id]
       # set current user object to @current_user object variable
      user = User.find session[:user_id] 
      #check if user is authenticated to perform restricted action
    end
  end
  
end
