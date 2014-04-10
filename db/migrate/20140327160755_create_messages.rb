class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.belongs_to :user
      t.string :subject
      t.string :contents
      t.integer :receiver_id
      t.timestamps
    end
  end
end
