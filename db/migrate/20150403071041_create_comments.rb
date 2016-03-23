class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.belongs_to :user
      t.belongs_to :product
      t.timestamps null: false
    end
    add_index :comments, :user_id
  end
end
