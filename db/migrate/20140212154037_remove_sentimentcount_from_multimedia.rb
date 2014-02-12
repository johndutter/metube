class RemoveSentimentcountFromMultimedia < ActiveRecord::Migration
  def change
    remove_column :multimedia, :likes
    remove_column :multimedia, :dislikes
  end
end
