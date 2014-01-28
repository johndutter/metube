class PartialController < ApplicationController
  before_action :check_login, only: [:show_secured]

  def show
    render "partial/" + params[:partial] , :layout => false
  end

  def show_secured
    # do auth logic
    render "secured/" + params[:partial] , :layout => false
  end

  private
  
  #don't allow logged in user to access log in page
  def check_login
    if session[:user_id]
      return true
    else
      head :unauthorized
    end
  end

end
