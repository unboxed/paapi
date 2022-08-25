class CreateInitialSchema < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :full, null: false
      t.string :town
      t.string :postcode
      t.string :longitude
      t.string :latitude

      t.timestamps
    end

    create_table :local_authorities do |t|
      t.string :name, null: false

      t.timestamps
    end

    create_table :planning_applications do |t|
      t.string :reference, null: false
      t.string :area, null: false
      t.string :proposal, null: false
      t.datetime :received_at, null: false
      t.string :officer_name
      t.string :decision, null: false
      t.datetime :decision_issued_at, null: false
      t.references :property, null: false
      t.references :local_authority, null: false

      t.timestamps
    end

    create_table :properties do |t|
      t.string :uprn
      t.references :address, null: false

      t.timestamps
    end
  end
end
