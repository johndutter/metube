class CreateSentiments < ActiveRecord::Migration
  def change
    create_table :sentiments do |t|
      t.belongs_to :user
      t.integer :multimedia_id
      t.boolean :like
      t.boolean :dislike

      t.timestamps
    end
  end
end
