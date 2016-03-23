class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.string :picture
      t.string :url

      t.timestamps null: false
    end
  end
end
