class AddLatitudeAndLongitudeToAddresses < ActiveRecord::Migration[7.0]
  def change
    change_table :addresses, bulk: true do |t|
      t.string :latitude
      t.string :longitude
    end
  end
end
