class AddMoreFieldsToProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :type, :string
    add_column :properties, :ward, :string
    add_column :properties, :ward_name, :string
  end
end
