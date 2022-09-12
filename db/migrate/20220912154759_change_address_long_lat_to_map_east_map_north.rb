class ChangeAddressLongLatToMapEastMapNorth < ActiveRecord::Migration[7.0]
  def change
    rename_column :addresses, :longitude, :map_east
    rename_column :addresses, :latitude, :map_north
  end
end
