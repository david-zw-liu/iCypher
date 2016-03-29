class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :public_key
      t.string :private_key
      t.timestamps null: false
    end
  end
end
