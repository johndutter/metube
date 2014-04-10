class ChangeColumnInMessages < ActiveRecord::Migration
  def change
    change_column :messages, :contents, :text
  end
end
