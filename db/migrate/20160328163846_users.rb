class Users < ActiveRecord::Migration
  def change
	  add_column :users, :modulus, :string
	  rename_column :users, :public_key, :public_exponent
	  rename_column :users, :private_key, :private_exponent
  end
end
