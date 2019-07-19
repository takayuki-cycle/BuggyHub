class AddMeanStarImgMaps < ActiveRecord::Migration[5.2]
  def change
    add_column :maps, :mean_star_img, :string
  end
end
