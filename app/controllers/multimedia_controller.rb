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
    user = User.find(params[:user_id])
    #only retrieve media that aren't currently being transcoded
    all_multimedia = Multimedia.find_by_sql("SELECT multimedia.* FROM multimedia LEFT JOIN delayed_jobs ON multimedia.id=delayed_jobs.multimedia_id WHERE delayed_jobs.multimedia_id IS NULL")

    render :json => {all_multimedia: all_multimedia}, status: :ok
  rescue ActiveRecord::RecordNotFound
    render :json => {message: 'Unable to get user multimedia.  User with id:' + params[:user_id] + ' could not be found.'}, status: :bad_request
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

  def get_multimedia
    category_id = Category.where('name = ?', params[:category])[0][:id]
    some_multimedia= []
    if params[:ordering] == 'views'
      some_multimedia = Multimedia.where('category_id = ?', category_id).order('views DESC').limit(params[:number]).offset(params[:offset])
    end
    if params[:ordering] == 'recent'
      some_multimedia = Multimedia.where('category_id = ?', category_id).order('created_at DESC').limit(params[:number]).offset(params[:offset])
    end
    render :json => {multimedia: some_multimedia}, status: :ok
  rescue
    render :json => {}, status: :bad_request
  end

  def get_analytics
    multimedia = Multimedia.select('id, user_id, title, created_at, views, thumbnail_path, mediaType').order('created_at DESC').limit(100).to_a
    completed_multimedia = []
    multimedia.each do |entry|
      sentiments = Multimedia.find(entry.id).sentiments.count
      date = String(entry.created_at)[0..18]
      tmp_entry = {:id => entry.id, :user_id => entry.user_id, :title => entry.title, :Date => date, :Views => entry.views, :thumbnail_path => entry.thumbnail_path, :mediaType => entry.mediaType, :sentiments => sentiments}
      completed_multimedia.push(tmp_entry)
    end

    early_side = String(multimedia[-1].created_at)[0..9]
    late_side = String(multimedia[0].created_at)[0..9]

    render :json => {multimedia: completed_multimedia, info: {early_side: early_side, late_side: late_side}}, status: :ok
  rescue
    render :json => {}, status: :bad_request
  end

  def get_recommended
    mainMult = Multimedia.find(params[:multimedia_id])
    tags = Multimedia.find(params[:multimedia_id]).tags.to_a
    recommended = []

    # get multimedia with similar tags
    tags.each do |tag|
      added_tags = Tag.where('name = ?', tag.name).to_a
      added_tags.each do |inner_tag|
        mult = Multimedia.find(inner_tag.multimedia_id)
        if (!recommended.include?(mult) && mult.id != params[:multimedia_id].to_i && recommended.length < 11)
          recommended.push(mult)
        end
      end
    end

    # get multimedia by same uploader
    if (recommended.length < 11)
      uploader_mult = Multimedia.where('user_id = ?', mainMult.user_id).limit(10).to_a
      uploader_mult.each do |entry|
        if (!recommended.include?(entry) && entry.id != params[:multimedia_id].to_i && recommended.length < 11)
          recommended.push(entry)
        end
      end
    end

    # get multimedia from same category
    if (recommended.length < 11)
      category_mult = Multimedia.where('category_id = ?', mainMult.category_id).limit(10).to_a
      category_mult.each do |entry|
        if (!recommended.include?(entry) && entry.id != params[:multimedia_id].to_i && recommended.length < 11)
          recommended.push(entry)
        end
      end
    end

    if (recommended.length > 10)
      recommended = recommended[0 .. 9]
    end

    rec_return = []
    recommended.each do |entry|
      username = User.find(entry.user_id).username
      rec_return.push({:id => entry.id, :title => entry.title, :username => username, :thumbnail_path => entry.thumbnail_path})
    end

    render :json => {recommended: rec_return}, status: :ok
  rescue
    render :json => {message: 'Error finding recommended multimedia.'}, status: :bad_request
  end

  def get_search_results
    searchparam = '%' + params[:query] + '%'
    multimedia_set = Multimedia.where('title like ? or description like ?', searchparam, searchparam).to_set

    # search tags as well
    tags_arr = Tag.where('name like ?', searchparam)
    tags_arr.each do |tag|
      media = Multimedia.find(tag.multimedia_id);
      multimedia_set.add(media)
    end

    render :json => {results: multimedia_set}, status: :ok
  rescue
    render :json => {message: 'Error retrieving search results.'}, status: :bad_request
  end
  
  private
  def multimedia_params
    params.require(:multimedia).permit(:title, :mediaType, :description, :user_id, :category_id);
  end
  
  def set_user
    params[:multimedia][:user_id] = session[:user_id]
  end
  
end
