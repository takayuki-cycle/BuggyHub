class AddRemarkToMaps < ActiveRecord::Migration[5.2]
  def change
    add_column :maps, :remark, :text
  end
end