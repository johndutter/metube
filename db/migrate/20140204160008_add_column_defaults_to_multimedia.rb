class AddColumnDefaultsToMultimedia < ActiveRecord::Migration
  def change
    change_column :multimedia, :views, :integer, :default => 0
    change_column :multimedia, :likes, :integer, :default => 0
    change_column :multimedia, :dislikes, :integer, :default => 0
  end
end
