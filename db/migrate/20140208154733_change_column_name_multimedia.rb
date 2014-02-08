class ChangeColumnNameMultimedia < ActiveRecord::Migration
  def change
    rename_column :multimedia, :type, :mediaType
  end
end
