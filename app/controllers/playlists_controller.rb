class PlaylistsController < ApplicationController
  def create_playlist
    # INSERT INTO playlists VALUES (<user_id>, <name>, <description>);
    @playlist = Playlist.new(playlist_params)
    if(@playlist.save)
      render :json => {playlist_id: @playlist[:id]}, status: :ok
    else
      render :json => {message: 'Unable to create playlist: ' + @playlist[:name]}, status: :bad_request
    end
  end

  def get_playlist_info
    # SELECT * FROM playlists WHERE id = <playlist_id>;
    @playlist = Playlist.find(params[:playlist_id])
    # SELECT * FROM users WHERE id = <user_id>;
    user = User.find(@playlist[:user_id])
    # SELECT COUNT(*) FROM playlist_entries WHERE playlist_id = <playlist_id>;
    count = @playlist.playlist_entries.count

    render :json => {playlist_info: {id: @playlist[:id], name: @playlist[:name], views: @playlist[:views], description: @playlist[:description], count: count, creator: user[:username]} }, status: :ok

  rescue ActiveRecord::RecordNotFound
    render :json => {message: 'Unable to retrieve playlist information for playlist with id:' + params[:playlist_id]}
  end

  def get_user_playlists
    # SELECT * FROM users WHERE id = <user_id>;
    user = User.find(params[:user_id])

    # SELECT * FROM playlists WHERE user_id = <user_id>;
    uploaded_playlists = user.playlists.to_a
    render :json => {uploaded_playlists: uploaded_playlists}, status: :ok

  rescue ActiveRecord::RecordNotFound
    render :json => {message: 'Unable to load playlists.  User with userid: ' + params[:user_id] + ' could not be found.'}, status: :bad_request
  end

  def get_user_liked_playlists
    # SELECT * FROM playlists LEFT OUTER JOIN playlist_sentiments ON playlists.id = playlist_sentiments.playlist_id WHERE playlist_sentiments.user_id = <user_id> AND playlist_sentiments.like = <true>;
    liked_playlists = Playlist.joins(:playlist_sentiments).where('playlist_sentiments.user_id = ? AND playlist_sentiments.like = ?', params[:user_id], true).to_a
    render :json => {liked_playlists: liked_playlists}, status: :ok
  end

  #get media necessary to create playlist thumbnails
  def get_playlist_thumbnails
    # SELECT * FROM playlist_entries WHERE playlist_id = <playlist_id>;
    playlist_entries = Playlist.find(params[:playlist_id]).playlist_entries.to_a
    thumbnail_media = []
    entry_counter = 0

    while (entry_counter < playlist_entries.length && entry_counter < 2) do
      # SELECT * FROM multimedia WHERE id = <multimedia_id>;
      multimedia = Multimedia.find(playlist_entries[entry_counter][:multimedia_id])
      thumbnail_media.push(multimedia)
      entry_counter+=1
    end

    render :json => {thumbnail_media: thumbnail_media}, status: :ok

  rescue ActiveRecord::RecordNotFound
    render :json => {message: 'Unable to load thumbnails.  Playlist with playlistid: ' + params[:playlist_id] + ' could not be found.'}, status: :bad_request
  end

  def add_media_to_playlist
    # SELECT * FROM playlists WHERE id = <playlist_id>;
    @playlist = Playlist.find(params[:playlist_id])
    # check to see if multimedia exists
    # SELECT * FROM multimedia WHERE id = <multimedia_id>; 
    multimedia = Multimedia.find(params[:multimedia_id])
    
    # UPDATE playlists SET count = count + 1 WHERE id = <playlist_id>;
    @playlist.increment(:count, by = 1)
    # INSERT INTO playlist_entries VALUES (<playlist_id>, <multimedia_id>);
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
    # SELECT * FROM playlists WHERE id = <playlist_id>;
    @playlist = Playlist.find(params[:playlist_id])
    # UPDATE playlists SET count = count - 1 WHERE id = <playlist_id>;
    @playlist.decrement(:count, by = 1)
    # DELETE FROM playlist_entries WHERE playlist_id = <playlist_id> AND multimedia_id = <multimedia_id>;
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
    # SELECT * FROM playlist_entries WHERE playlist_id = <playlist_id> AND multimedia_id = <multimedia_id>;
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
    # SELECT  * FROM playlists WHERE id = <playlist_id>;
    @playlist = Playlist.find(params[:playlist_id])
    # UPDATE playlists SET views = views + 1 WHERE id = <playlist_id>;
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
    # SELECT * FROM playlists WHERE id = <playlist_id>;
    @playlist = Playlist.find(params[:playlist_id])
    # DELETE FROM playlists WHERE id = <playlist_id>;
    @playlist.destroy

    if(@playlist.destroyed?)
      render :json => {}, status: :ok
    else
      render :json => {message: "Unable to delete playlist with id:" + params[:playlist_id]}
    end

  rescue ActiveRecord::RecordNotFound
    render :json => {message: 'Unable to delete playlist.  Playist with id:' + params[:playlist_id] + ' could not be found'}
  end

  def get_playlists
    # SELECT playlists.id, playlists.count, playlists.description, playlists.name, playlists.views, users.username as username FROM playlists LEFT OUTER JOIN users ON users.id = playlists.user_id ORDER BY playlists.created_at DESC
    playlists = Playlist.find(:all, :select => 'playlists.id, playlists.count, playlists.description, playlists.name, playlists.views, users.username as username', :joins => 'left outer join users on users.id = playlists.user_id', :order => 'playlists.created_at DESC').to_a
    render :json => {playlists: playlists}, status: :ok
  rescue ActiveRecord::RecordNotFound
    render :json => {message: 'Unable to return playlists.'}, status: :bad_request
  end

  def get_few_playlists
    # SELECT playlists.id, playlists.name, users.username as username FROM playlists LEFT OUTER JOIN users ON users.id = playlists.user_id ORDER BY playlists.created_at DESC LIMIT 5
    playlists = Playlist.find(:all, :select => 'playlists.id, playlists.name, users.username as username', :joins => 'left outer join users on users.id = playlists.user_id', :order => 'playlists.created_at DESC', :limit => 5).to_a
    render :json => {playlists: playlists}, status: :ok
  rescue ActiveRecord::RecordNotFound
    render :json => {message: 'Unable to return playlists.'}, status: :bad_request
  end

  def get_user_playlists_overview
    # SELECT playlists.id, playlists.name, users.username as username FROM playlists LEFT OUTER JOIN users ON users.id = playlists.user_id WHERE playlists.user_id = <user_id> ORDER BY playlists.created_at DESC LIMIT 5
    playlists = Playlist.where('user_id = ?', params[:user_id]).find(:all, :select => 'playlists.id, playlists.name, users.username as username', :joins => 'left outer join users on users.id = playlists.user_id', :order => 'playlists.created_at DESC', :limit => 5).to_a
    render :json => {playlists: playlists}, status: :ok
  rescue ActiveRecord::RecordNotFound
    render :json => {message: 'Unable to return playlists.'}, status: :bad_request
  end

  private
    def playlist_params
      params.require(:playlist).permit(:user_id, :name, :description)
    end
end
