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

ActiveRecord::Schema[7.0].define(version: 2023_02_07_221712) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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
    t.string "latitude"
    t.string "longitude"
    t.bigint "property_id", null: false
    t.index ["property_id"], name: "index_addresses_on_property_id"
  end

  create_table "api_clients", force: :cascade do |t|
    t.string "client_name", null: false
    t.string "client_secret", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_name"], name: "index_api_clients_on_client_name", unique: true
    t.index ["client_secret"], name: "index_api_clients_on_client_secret", unique: true
  end

  create_table "csv_processing_messages", force: :cascade do |t|
    t.string "body"
    t.jsonb "data"
    t.bigint "csv_upload_id", null: false
    t.index ["csv_upload_id"], name: "index_csv_processing_messages_on_csv_upload_id"
  end

  create_table "csv_uploads", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "local_authorities", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "api_client_id"
    t.index ["api_client_id"], name: "index_local_authorities_on_api_client_id"
  end

  create_table "planning_applications", force: :cascade do |t|
    t.string "reference", null: false
    t.string "area", null: false
    t.string "description", null: false
    t.datetime "received_at", null: false
    t.string "assessor"
    t.string "decision", null: false
    t.datetime "decision_issued_at", null: false
    t.bigint "local_authority_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "view_documents"
    t.string "application_type"
    t.string "reviewer"
    t.datetime "validated_at"
    t.string "application_type_code"
    t.index ["local_authority_id"], name: "index_planning_applications_on_local_authority_id"
    t.index ["reference", "local_authority_id"], name: "index_planning_applications_on_reference_and_local_authority_id", unique: true
  end

  create_table "planning_applications_properties", force: :cascade do |t|
    t.bigint "planning_application_id"
    t.bigint "property_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["planning_application_id"], name: "idx_planning_applications_properties_on_planning_application"
    t.index ["property_id"], name: "idx_planning_applications_properties_on_property"
  end

  create_table "properties", force: :cascade do |t|
    t.string "uprn", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", null: false
    t.string "code", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "properties"
  add_foreign_key "planning_applications_properties", "planning_applications"
  add_foreign_key "planning_applications_properties", "properties"
end
