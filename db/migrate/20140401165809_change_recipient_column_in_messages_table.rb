class ChangeRecipientColumnInMessagesTable < ActiveRecord::Migration
  def change
    remove_column :messages, :receiver_id
    add_column :messages, :recipient_name, :string
  end
end
