class AddColumnsToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :subscription_id, :integer
  end
end
