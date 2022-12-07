class AddressBelongsToProperty < ActiveRecord::Migration[7.0]
  def change
    add_reference :addresses, :property, foreign_key: true, index: true

    up_only do
      execute <<-SQL
        UPDATE addresses AS a SET property_id = p.id
        FROM properties AS p WHERE a.id = p.address_id
      SQL

      change_column_null :addresses, :property_id, false
    end
  end
end
