class AddThumbnailPathColumnToMultimedia < ActiveRecord::Migration
  def change
  	add_column :multimedia, :thumbnail_path, :string
  end
end
