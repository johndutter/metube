class AddColumnToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :views, :integer, :default => 0
  end
end
