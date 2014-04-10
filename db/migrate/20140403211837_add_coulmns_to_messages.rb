class AddCoulmnsToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :deleted_by_sender, :boolean, :default => 0
    add_column :messages, :deleted_by_recipient, :boolean, :default => 0
    add_column :messages, :unread, :boolean, :default => 1
  end
end
