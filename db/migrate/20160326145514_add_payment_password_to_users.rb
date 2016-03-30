class AddPaymentPasswordToUsers < ActiveRecord::Migration
  def change
    add_column :users, :money, :decimal, precision: 8, scale: 2
    add_column :users, :payment_password, :string
  end
end
