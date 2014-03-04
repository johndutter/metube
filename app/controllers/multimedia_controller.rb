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
    media_save_path = '/uploads/' + params[:multimedia_id] + params[:mediaType]
    Multimedia.store_media(params[:fileData], params[:multimedia_id], params[:mediaType])

    if(params[:mediaType] == '.avi')
      transcode_avi_to_mp4('public' + media_save_path, params[:multimedia_id])
    end

    if(@multimedia.update( path: media_save_path ))
      save_thumbnail('public' + media_save_path, @multimedia[:mediaType])
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
    case mediaType
    when 'video'
      save_video_thumbnail(mediaFilePath)
    when 'audio'
      save_audio_thumbnail()
    when 'image'
      save_image_thumbnail(mediaFilePath)
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

  def save_audio_thumbnail()
    thumbnail_path = '/assets/audio_thumb.jpg'

    if(@multimedia.update(thumbnail_path: thumbnail_path))
      render :json => {multimedia: @multimedia[:id]}, staus: :ok
    else
      render :json => {message: 'Thumbnail information could not be saved'}, status: :bad_request
    end
  end

  def save_image_thumbnail(imageFilePath)
    thumbnail_path = generateImageThumbnail(imageFilePath)

    if(@multimedia.update(thumbnail_path: thumbnail_path))
      render :json => {multimedia: @multimedia[:id]}, staus: :ok
    else
      render :json => {message: 'Thumbnail information could not be saved'}, status: :bad_request
    end
  rescue Magick::ImageMagickError
     render :json => {message: 'imagemagick could not generate the thumbnail'}, status: :bad_request
  end

  def get_multimedia_info
    @multimedia = Multimedia.find(params[:id])
    tags = @multimedia.tags.map(&:name).join(', ')
    render :json => { id: @multimedia[:id], title: @multimedia[:title], views: @multimedia[:views], user_id: @multimedia[:user_id], description: @multimedia[:description], path: @multimedia[:path], tags: tags, mediaType: @multimedia[:mediaType] }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render :json => { }, status: :bad_request
  end

  def get_multimedia_progress
    @multimedia = Multimedia.find(params[:multimedia_id])
    delayed_job = @multimedia.delayed_job
    if(delayed_job != nil)
      progress = delayed_job[:job_progress]
    else
      #if job is complete send back progress of 100
      progress = 100
    end

    render :json => {progress: progress}, status: :ok

  rescue ActiveRecord::RecordNotFound
    render :json => {}, status: :bad_request
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

  def get_user_multimedia
    #returns empty set if where query doesn't match anything
    all_videos = Multimedia.where('user_id = ? AND mediaType=?', params[:user_id], 'video').to_a
    all_images = Multimedia.where('user_id = ? AND mediaType=?', params[:user_id], 'image').to_a
    all_audio  = Multimedia.where('user_id = ? AND mediaType=?', params[:user_id], 'audio').to_a

    render :json => {videos: all_videos, images: all_images, audio:all_audio}, status: :ok
  end

  def get_playlist_multimedia
    playlist_entries = PlaylistEntry.where('playlist_id = ?', params[:playlist_id]).to_a
    all_multimedia = []

    playlist_entries.each do |entry|
      multimedia = Multimedia.find(entry[:multimedia_id])
      all_multimedia.push(multimedia)
    end
    render :json => {all_multimedia: all_multimedia}, status: :ok
    
  rescue ActiveRecord::RecordNotFound
    render :json => {message: 'Playlist with id: ' + params[:playlist_id] + ' could not be found.'}, status: :bad_request
  end

  def download
    send_file 'public/uploads/' + params[:ending], :filename => params[:ending], :disposition => 'attachment'
  end
  
  private
  def multimedia_params
    params.require(:multimedia).permit(:title, :mediaType, :description, :user_id, :category_id);
  end
  
  def set_user
    params[:multimedia][:user_id] = session[:user_id]
  end
  
end
