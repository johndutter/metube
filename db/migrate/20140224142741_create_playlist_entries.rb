class CreatePlaylistEntries < ActiveRecord::Migration
  def change
    create_table :playlist_entries do |t|
      t.belongs_to :playlist
      t.integer :multimedia_id
      t.timestamps
    end
  end
end
