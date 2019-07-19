class AddReserveToMaps < ActiveRecord::Migration[5.2]
  def change
    add_column :maps, :reserve, :boolean, default: 0
  end
end