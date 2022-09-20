class AddWardToAddress < ActiveRecord::Migration[7.0]
  def change
    add_column :addresses, :ward_code, :string
    add_column :addresses, :ward_name, :string
  end
end
