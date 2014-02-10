class DropColumnMultimedia < ActiveRecord::Migration
  def change
  	remove_column :multimedia, :tags
  end
end
