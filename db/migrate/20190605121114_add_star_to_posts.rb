class AddStarToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :star, :integer
  end
end