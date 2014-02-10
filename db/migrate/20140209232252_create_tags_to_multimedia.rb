class CreateTagsToMultimedia < ActiveRecord::Migration
  def change
    create_table :tags_to_multimedia do |t|
      t.decimal :tag_id
      t.decimal :multimedia_id

      t.timestamps
    end
  end
end
