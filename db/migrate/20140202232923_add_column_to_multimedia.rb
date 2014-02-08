class AddColumnToMultimedia < ActiveRecord::Migration
  def change
    add_column :multimedia, :description, :text
  end
end
