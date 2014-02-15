class AddMultimediaToTags < ActiveRecord::Migration
  def change
    add_column :tags, :multimedia_id, :integer
  end
end
