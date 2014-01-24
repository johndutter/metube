class AddFieldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email, :string
    add_column :users, :iterations, :decimal
  end
end
