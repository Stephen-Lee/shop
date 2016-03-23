class CreateMarks < ActiveRecord::Migration
  def change
    create_table :marks do |t|
      t.belongs_to :user
      t.belongs_to :product
      t.timestamps null: false
    end
    add_index :marks, :user_id
    add_index :marks, :product_id
    add_index :marks, [:user_id,:product_id]
  end
end
