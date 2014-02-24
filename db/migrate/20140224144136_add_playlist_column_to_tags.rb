class AddPlaylistColumnToTags < ActiveRecord::Migration
  def change
    add_column :tags, :playlist_id, :integer
  end
end
