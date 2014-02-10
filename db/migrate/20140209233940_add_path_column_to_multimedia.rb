class AddPathColumnToMultimedia < ActiveRecord::Migration
  def change
  	add_column :multimedia, :path, :string
  end
end
