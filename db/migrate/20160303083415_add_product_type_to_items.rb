class AddProductTypeToItems < ActiveRecord::Migration
  def change
    add_column :items, :product_type, :string
  end
end
