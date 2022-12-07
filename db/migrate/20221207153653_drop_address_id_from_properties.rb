class DropAddressIdFromProperties < ActiveRecord::Migration[7.0]
  def change
    remove_reference :properties, :address
  end
end
