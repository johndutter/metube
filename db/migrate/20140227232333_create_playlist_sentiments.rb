class CreatePlaylistSentiments < ActiveRecord::Migration
  def change
    create_table :playlist_sentiments do |t|

      t.timestamps
    end
  end
end
