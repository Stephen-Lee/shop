class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :buyer
      t.string :phone
      t.string :address
      t.decimal :total, precision: 8, scale: 2, null: false
      t.belongs_to :user
      t.timestamps null: false
    end
    add_index :orders, :user_id
  end
end
