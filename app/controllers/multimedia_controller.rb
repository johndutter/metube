class MultimediaController < ApplicationController
  before_action :set_user, only: [:create]
  
  def create
    @multimedia = Multimedia.new(multimedia_params)
    @multimedia.set_path(params[:multimedia][:fileExtension])
    
    if(@multimedia.save && save_tag_data(params[:multimedia][:tags]))
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

  def save_tag_data(tags)
    all_tags = tags.split(',').map(&:strip)
    all_tags.each do |tag|
      @tag = Tag.new( {name: tag} )

      if(!@tag.save)
        return false
      else
        #on successful save, update the reference table
        if(!save_tag_to_multimedia_reference)
          return false
        end
      end
      
    end
    return true
  end

  def save_tag_to_multimedia_reference
    tag_id = Tag.last()[:id]
    multimedia_id = Multimedia.last()[:id]
    @tag_to_multimeda_reference = TagsToMultimedia.new( {tag_id: tag_id, multimedia_id: multimedia_id} )

    if(@tag_to_multimeda_reference.save)
      return true
    else
      return false
    end
  end
  
  private
  def multimedia_params
    params.require(:multimedia).permit(:title, :mediaType, :description, :user_id);
  end
  
  def set_user
    params[:multimedia][:user_id] = session[:user_id]
  end
  
end
