class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.belongs_to :multimedia
      t.integer :parent_id
      t.string :text

      t.timestamps
    end
  end
end
