class CreateAuthorities < ActiveRecord::Migration
  def change
    create_table :authorities do |t|
      t.belongs_to :user
      t.belongs_to :role
      t.timestamps null: false
    end
    add_index :authorities, :user_id
    add_index :authorities, :role_id
    add_index :authorities, [:user_id, :role_id]
  end
end
