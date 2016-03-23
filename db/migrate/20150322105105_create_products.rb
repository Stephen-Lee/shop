# -*- encoding : utf-8 -*-
class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price, precision: 8, scale: 2
      t.integer :inventory
      t.text :introduction
      t.string :picture
      t.integer :sales, default: 0
      t.timestamps null: false
    end
    add_index :products, :name
    add_index :products, :price
  end
end
