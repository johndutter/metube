class PlaylistsController < ApplicationController
  def create_playlist
    @playlist = Playlist.new(playlist_params)
    if(@playlist.save)
      render :json => {playlist_id: @playlist[:id]}, status: :ok
    else
      render :json => {message: 'Unable to create playlist: ' + @playlist[:name]}, status: :bad_request
    end
  end

  def get_playlist_info
    @playlist = Playlist.find(params[:playlist_id])
    user = User.find(@playlist[:user_id])

    render :json => {playlist_info: {id: @playlist[:id], name: @playlist[:name], views: @playlist[:views], description: @playlist[:description], creator: user[:username]} }, status: :ok

  rescue ActiveRecord::RecordNotFound
    render :json => {message: 'Unable to retrieve playlist information for playlist with id:' + params[:playlist_id]}
  end

  def get_user_playlists
    user = User.find(params[:user_id])
    results_limit = params[:limit]
    results_offset = params[:offset]

    uploaded_playlists = user.playlists.limit(results_limit).offset(results_offset).to_a
    render :json => {uploaded_playlists: uploaded_playlists}, status: :ok

  rescue ActiveRecord::RecordNotFound
    render :json => {message: 'Unable to load playlists.  User with userid: ' + params[:user_id] + ' could not be found.'}, status: :bad_request
  end

  def get_user_liked_playlists
    results_limit = params[:limit]
    results_offset = params[:offset]

    liked_playlists = Playlist.joins(:playlist_sentiments).where('playlist_sentiments.user_id = ? AND playlist_sentiments.like = ?', params[:user_id], true).to_a
    render :json => {liked_playlists: liked_playlists}, status: :ok
  end

  #get media necessary to create playlist thumbnails
  def get_playlist_thumbnails
    playlist_entries = Playlist.find(params[:playlist_id]).playlist_entries.to_a
    thumbnail_media = []
    entry_counter = 0

    while (entry_counter < playlist_entries.length && entry_counter < 2) do
      multimedia = Multimedia.find(playlist_entries[entry_counter][:multimedia_id])
      thumbnail_media.push(multimedia)
      entry_counter+=1
    end

    render :json => {thumbnail_media: thumbnail_media}, status: :ok

  rescue ActiveRecord::RecordNotFound
    render :json => {message: 'Unable to load thumbnails.  Playlist with playlistid: ' + params[:playlist_id] + ' could not be found.'}, status: :bad_request
  end

  def add_media_to_playlist
    @playlist = Playlist.find(params[:playlist_id])
    # check to see if multimedia exists
    multimedia = Multimedia.find(params[:multimedia_id])
    
    @playlist.increment(:count, by = 1)
    playlist_entry = PlaylistEntry.new({playlist_id: @playlist[:id], multimedia_id: multimedia[:id]})

    if(playlist_entry.save && @playlist.save)
      render :json => {}, status: :ok
    else
      render :json => {message: 'Unable to add media to playlist.'}
    end

  rescue ActiveRecord::RecordNotFound
    render :json => {message: 'Unable to add media. Media could not be found.'}, status: :bad_request
  end 

  def remove_media_from_playlist
    @playlist = Playlist.find(params[:playlist_id])
    @playlist.decrement(:count, by = 1)
    playlist_entry = PlaylistEntry.where('playlist_id = ? AND multimedia_id = ?', params[:playlist_id], params[:multimedia_id]).to_a[0]
    playlist_entry.delete

    if(playlist_entry.destroyed? && @playlist.save)
      render :json => {}, status: :ok
    else
      render :json => {message: 'Unable to delete media with id:' + params[:multimedia_id] + ' from playlist wth id:' + params[playlist_id]}, status: :bad_request
    end

  rescue ActiveRecord::RecordNotFound
    render :json => {message: 'Unable to remove media.  Playlist with id:' + params[:playlist_id] + ' could not be found'}, status: :bad_request
  end

  def playlist_has_multimedia?
    playlist_entry = PlaylistEntry.where('playlist_id = ? AND multimedia_id = ?', params[:playlist_id], params[:multimedia_id]).to_a[0]
    if(playlist_entry == nil)
      render :json => {has_multimedia: false}, status: :ok
    else
      render :json => {has_multimedia: true}, status: :ok
    end

  rescue ActiveRecord::ActiveRecordError
    render :json => {message: 'Database error. Please try again later.'}, status: :bad_request
  end

  def update_view_count
    @playlist = Playlist.find(params[:playlist_id])
    @playlist.increment(:views, by=1)
    if(@playlist.save)
      render :json => {}, status: :ok
    else
      render :json => {message: 'Unable to update view count for playlist with id ' + params[:playlist_id]}
    end

  rescue ActiveRecord::RecordNotFound
    render :json => {message: 'Unable to update view count.  Playlist with id:' + params[:playlist_id] + ' could not be found.'}
  end

  def delete_playlist
    @playlist = Playlist.find(params[:playlist_id])
    @playlist.destroy

    if(@playlist.is_destroyed?)
      render :json => {}, status: :ok
    else
      render :json => {message: "Unable to delete playlist with id:" + params[:playlist_id]}
    end

  rescue ActiveRecord::RecordNotFound
    render :json => {message: 'Unable to delete playlist.  Playist with id:' + params[:playlist_id] + ' could not be found'}
  end

  private
    def playlist_params
      params.require(:playlist).permit(:user_id, :name, :description)
    end
end
