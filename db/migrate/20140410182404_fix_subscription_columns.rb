class FixSubscriptionColumns < ActiveRecord::Migration
  def change
    remove_column :subscriptions, :views
    add_column :users, :views, :integer, :default => 0
  end
end
