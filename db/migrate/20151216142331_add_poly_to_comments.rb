class AddPolyToComments < ActiveRecord::Migration
  def change
  	add_reference :comments, :commentable, polymorphic: true,index: true
  	remove_column :comments, :product_id
  end
end
