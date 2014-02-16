class MultimediaController < ApplicationController
  include MultimediaHelper
  before_action :set_user, only: [:create]
  
  def create
    @multimedia = Multimedia.new(multimedia_params)

    if(@multimedia.save && save_tag_data(params[:multimedia][:tags], @multimedia[:id]))
      render :json => {multimedia: @multimedia[:id]}, status: :ok
    else
      render :json => {multimedia: 0}, status: :bad_request
    end
  end
  
  def save_file
    @multimedia = Multimedia.find(params[:multimedia_id])
    media_save_path = 'uploads/' + params[:multimedia_id] + params[:mediaType]
    Multimedia.store_media(params[:fileData], params[:multimedia_id], params[:mediaType])

    if(@multimedia.update( path: media_save_path ))
      save_thumbnail('public/' + media_save_path, @multimedia[:mediaType])
    else
      render :json => {message: 'Unable to save file to the server.'}, status: :bad_request
    end

  rescue ActiveRecord::RecordNotFound
    render :json => {message: 'Multimedia file with id: ' + params[:multimedia_id] + ' could not be found.'}, status: :bad_request
  rescue ApplicationHelper::FileSaveError
    #remove db record if file cannot be saved
    @multimedia.delete
    render :json => {message: 'Error when writing file.  File could not be saved'}, status: :bad_request
  end

  def save_thumbnail(mediaFilePath, mediaType)
    logger.info "inside save_thumbnail"
    case mediaType
    when 'video'
      save_video_thumbnail(mediaFilePath)
    when 'audio'
      #save_audio_thumbnail
      render :json => {}, status: :ok
    when 'image'
      #save_image_thumbnail
      render :json => {}, status: :ok
    else
      render :json => {message: 'Thumbnails could not be generated for the multimedia file.'}, status: :bad_request
    end
  end

  def save_video_thumbnail(videoFilePath)
    #first the thumbnails need to be generated
    thumbnail_path = generateThumbnail(videoFilePath)

    if(@multimedia.update(thumbnail_path: thumbnail_path))
      render :json => {multimedia: @multimedia[:id]}, staus: :ok
    else
      render :json => {message: 'Thumbnail information could not be saved'}, status: :bad_request
    end

  rescue FFMPEG::Error
    render :json => {message: 'ffmpeg could not generate thumbnail', status: :bad_request}
  end

  def get_multimedia_info
    @multimedia = Multimedia.find(params[:id])
    tags = @multimedia.tags.map(&:name).join(', ')
    render :json => { id: @multimedia[:id], title: @multimedia[:title], views: @multimedia[:views], user_id: @multimedia[:user_id], description: @multimedia[:description], path: @multimedia[:path], tags: tags }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render :json => { }, status: :bad_request
  end

  def update_view_count
    @multimedia = Multimedia.find(params[:id])
    @multimedia.increment(:views, by = 1)
    if @multimedia.save
      render :json => { }, status: :ok
    else
      render :json => { }, status: :bad_request
    end
  rescue ActiveRecord::RecordNotFound
    render :json => { }, status: :bad_request
  end

  def save_tag_data(tags, multimedia_reference_id)
    all_tags = tags.split(',').map(&:strip).reject(&:empty?)
    all_tags.each do |tag|
      @tag = Tag.new( {name: tag, multimedia_id: multimedia_reference_id} )

      if(!@tag.save)
        return false
      end
      
    end
    return true
  end

  def save_tag_to_multimedia_reference(tag_id, multimedia_reference_id)
    @tag_to_multimeda_reference = TagsToMultimedia.new( {tag_id: tag_id, multimedia_id: multimedia_reference_id} )

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
