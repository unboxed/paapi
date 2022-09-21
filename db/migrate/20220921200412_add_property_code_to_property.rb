class AddPropertyCodeToProperty < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :code, :string
  end
end
