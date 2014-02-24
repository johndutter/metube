class AddDefaultsToPlaylist < ActiveRecord::Migration
  def change
    change_column :playlists, :public, :boolean, :default => 1
    change_column :playlists, :views, :integer, :default => 0
  end
end
