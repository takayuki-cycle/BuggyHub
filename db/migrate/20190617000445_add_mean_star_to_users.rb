class AddMeanStarToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :mean_star, :decimal, :precision => 5, :scale => 4
  end
end
