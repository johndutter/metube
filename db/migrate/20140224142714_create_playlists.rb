class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.belongs_to :user
      t.string :name
      t.string :description
      t.boolean :public
      t.integer :views
      t.timestamps
    end
  end
end
