class CreateMaps < ActiveRecord::Migration[5.2]
  def change
    create_table :maps do |t|
      t.boolean :storage
      t.string :area
      t.decimal :lat, :precision => 11, :scale => 8
      t.decimal :lng, :precision => 11, :scale => 8
      t.datetime :service_start
      t.datetime :service_end
      t.integer :ride
      t.integer :user_id

      t.timestamps
    end
  end
end