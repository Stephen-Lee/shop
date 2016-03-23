class AddTotalToItems < ActiveRecord::Migration
  def change
    add_column :items, :total, :decimal, precision: 8, scale: 2
  end
end
