class PartialController < ApplicationController
  before_action :check_login, only: [:show_secured]

  def show
    render "partial/" + params[:partial] , :layout => false
  end

  def show_secured
    # do auth logic
    render "secured/" + params[:partial] , :layout => false
  end

end
