class AddImageNameBinaryToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :image_name_binary, :text
  end
end