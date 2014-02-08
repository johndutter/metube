class CreateMultimedia < ActiveRecord::Migration
  def change
    create_table :multimedia do |t|
      t.string :title
      t.integer :views
      t.string :type
      t.integer :likes
      t.integer :dislikes
      t.string :tags
      t.integer :user_id

      t.timestamps
    end
  end
end
