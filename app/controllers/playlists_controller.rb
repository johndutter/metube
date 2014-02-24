class PlaylistsController < ApplicationController
  def create_playlist
    @playlist = Playlist.new(playlist_params)
    if(@playlist.save)
      render :json => {playlist_id: @playlist[:id]}, status: :ok
    else
      render :json => {message: 'Unable to create playlist: ' + @playlist[:name]}, status: :bad_request
    end
  end

  private
    def playlist_params
      params.require(:playlist).permit(:user_id, :name, :description)
    end
end
