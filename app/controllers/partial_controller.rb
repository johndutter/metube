class PartialController < ApplicationController

  def show
    render "partial/" + params[:partial] , :layout => false
  end

  def show_secured
    # do auth logic
    render "secured/" + params[:partial] , :layout => false
  end

end
