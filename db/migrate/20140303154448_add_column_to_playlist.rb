class AddColumnToPlaylist < ActiveRecord::Migration
  def change
    add_column :playlists, :count, :integer, :default => 0
  end
end
