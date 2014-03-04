class AddColumnsToPlaylistSentiments < ActiveRecord::Migration
  def change
    add_column :playlist_sentiments, :user_id, :integer
    add_column :playlist_sentiments, :playlist_id, :integer
    add_column :playlist_sentiments, :like, :boolean
  end
end
