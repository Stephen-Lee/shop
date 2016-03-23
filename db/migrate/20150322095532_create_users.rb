# -*- encoding : utf-8 -*-
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :nick_name
      t.string :address
      t.string :phone
      t.string :real_name
      t.string :avatar
      t.datetime :ban_comment_until
      t.decimal :score, precision: 8, scale: 2,default: 0,null: false
      t.timestamps null: false
    end
   
  end
end
