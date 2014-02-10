class MultimediaController < ApplicationController
  before_action :set_user, only: [:create]
  
  def create
    @multimedia = Multimedia.new(multimedia_params)
    
    if(@multimedia.save)
      render :json => {multimedia: @multimedia[:id]}, status: :ok
    else
      render :json => {multimedia: 0}, status: :bad_request
    end
  end
  
  def save_file
    if(Multimedia.store_media(params[:fileData], params[:multimedia_id], params[:mediaType]))
      render :json => { }, status: :ok
    else
      render :json => { }, status: :bad_request
    end
  end

  def get_multimedia_info
    @multimedia = Multimedia.find(params[:id])
    logger.info(@multimedia.to_yaml)
    render :json => { id: @multimedia[:id], title: @multimedia[:title], likes: @multimedia[:likes], dislikes: @multimedia[:dislikes], user_id: @multimedia[:user_id], description: @multimedia[:description] }, status: :ok
  rescue
    render :json => { }, status: :bad_request
  end
  
  private
  def multimedia_params
    params.require(:multimedia).permit(:title, :tags, :mediaType, :description, :user_id);
  end
  
  def set_user
    params[:multimedia][:user_id] = session[:user_id]
  end
  
end
