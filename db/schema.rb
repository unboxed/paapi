# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_10_14_123048) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "full", null: false
    t.string "town"
    t.string "postcode"
    t.string "map_east"
    t.string "map_north"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ward_code"
    t.string "ward_name"
  end

  create_table "local_authorities", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "planning_applications", force: :cascade do |t|
    t.string "reference", null: false
    t.string "area", null: false
    t.string "description", null: false
    t.datetime "received_at", null: false
    t.string "assessor"
    t.string "decision", null: false
    t.datetime "decision_issued_at", null: false
    t.bigint "property_id", null: false
    t.bigint "local_authority_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "view_documents"
    t.index ["local_authority_id"], name: "index_planning_applications_on_local_authority_id"
    t.index ["property_id"], name: "index_planning_applications_on_property_id"
  end

  create_table "properties", force: :cascade do |t|
    t.string "uprn"
    t.bigint "address_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.string "code"
    t.index ["address_id"], name: "index_properties_on_address_id"
  end

end
