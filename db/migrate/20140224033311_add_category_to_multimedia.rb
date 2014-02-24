class AddCategoryToMultimedia < ActiveRecord::Migration
  def change
    add_column :multimedia, :category_id, :integer
  end
end
