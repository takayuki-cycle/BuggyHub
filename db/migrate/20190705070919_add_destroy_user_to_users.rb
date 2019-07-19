class AddDestroyUserToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :destroy_user, :boolean
  end
end