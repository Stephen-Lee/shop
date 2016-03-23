class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :verify_code
      t.integer :value
      t.datetime :expire_at
      t.belongs_to :user
      t.timestamps null: false
    end
    add_index :coupons, :user_id
  end
end
