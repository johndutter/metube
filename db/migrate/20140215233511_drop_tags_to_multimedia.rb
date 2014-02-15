class DropTagsToMultimedia < ActiveRecord::Migration
  def change
    drop_table :tags_to_multimedia
  end
end
