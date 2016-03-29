class RemoveColAccessKeyFromUser < ActiveRecord::Migration
  def change
		remove_column :users, :access_key
  end
end
