class AddEmailAndFullnameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email, :string
    add_column :users, :full_name, :string
  end
end
