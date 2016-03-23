class AddPropertiesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sex, :string
    add_column :users, :s_province, :string
    add_column :users, :s_city, :string
    add_column :users, :s_county, :string
    add_column :users, :age, :integer
  end
end
