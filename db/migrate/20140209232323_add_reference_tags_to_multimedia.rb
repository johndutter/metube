class AddReferenceTagsToMultimedia < ActiveRecord::Migration
  def change
  	change_column :tags_to_multimedia, :tag_id, :integer
  	change_column :tags_to_multimedia, :multimedia_id, :integer, :references => 'multimedia(id) ON DELETE CASCADE'
  end
end
