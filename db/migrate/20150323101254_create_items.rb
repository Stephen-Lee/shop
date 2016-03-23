class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer	:quantity, default: 1
      t.belongs_to :product
      t.belongs_to :cart
      t.belongs_to :order
      t.timestamps null: false
    end
    add_index :items, :product_id
    add_index :items, :cart_id
    add_index :items, :order_id
  end
end
