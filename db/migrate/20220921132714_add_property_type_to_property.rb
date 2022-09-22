class AddPropertyTypeToProperty < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :type, :string
  end
end
