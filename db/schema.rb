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

ActiveRecord::Schema[8.0].define(version: 2025_03_05_152250) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "unaccent"
  enable_extension "uuid-ossp"

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
    t.string "street"
    t.string "complement"
    t.string "postal_code"
    t.string "city"
    t.string "country", default: "France"
    t.string "entered_by_user"
    t.float "latitude"
    t.float "longitude"
    t.jsonb "geocoder_value", default: {}
    t.integer "zoom"
    t.string "addressable_type", null: false
    t.bigint "addressable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name", null: false
    t.integer "client_type", default: 0, null: false
    t.string "logo"
    t.integer "role"
    t.string "reference"
    t.bigint "heading_id"
    t.bigint "company_id"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "commercial_details", force: :cascade do |t|
    t.bigint "commercial_id"
    t.boolean "display_unit_count", default: false, null: false
    t.boolean "display_description", default: false, null: false
    t.boolean "display_empty_fields", default: false, null: false
    t.boolean "display_footer", default: false, null: false
    t.boolean "display_global_discount", default: false, null: false
    t.boolean "display_discount", default: false, null: false
    t.boolean "display_heading", default: false, null: false
    t.boolean "display_legal_mentions", default: false, null: false
    t.boolean "display_amount_before_tax", default: false, null: false
    t.boolean "display_days_column", default: false, null: false
    t.boolean "display_days", default: false, null: false
    t.boolean "display_service_details", default: false, null: false
    t.boolean "display_quantity", default: false, null: false
    t.boolean "display_reference", default: false, null: false
    t.boolean "display_title", default: false, null: false
    t.boolean "display_total_with_tax", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "commercials", force: :cascade do |t|
    t.bigint "intervention_id"
    t.bigint "user_id"
    t.bigint "client_id"
    t.bigint "facture_id"
    t.bigint "heading_id"
    t.bigint "prestation_id"
    t.bigint "company_id"
    t.bigint "report_id"
    t.bigint "template_id"
    t.bigint "created_by"
    t.string "reference"
    t.date "validate_date"
    t.text "pretations_details"
    t.integer "state", default: 0
    t.date "signed_before"
    t.date "signed_at"
    t.boolean "must_signed"
    t.text "description"
    t.string "document_title"
    t.integer "prefix_type"
    t.integer "reduction_unit"
    t.float "reduction", default: 0.0
    t.date "send_at"
    t.string "photo"
    t.string "type"
    t.string "template_name", default: ""
    t.boolean "is_template", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string "social_reason"
    t.string "siren"
    t.string "num_tva"
    t.string "email"
    t.string "tel"
    t.text "footer_page"
    t.text "activity"
    t.date "creation_date"
    t.string "logo"
    t.string "establishment"
    t.string "iban"
    t.string "bic"
    t.integer "taux_tva"
    t.string "prefix_bill", default: "FACT-(AA)-(mois)-"
    t.string "prefix_quote", default: "DEV-(AA)-(mois)-"
    t.string "prefix_credit", default: "AVR-(AA)-(mois)-"
    t.string "subdomain"
    t.boolean "is_archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.bigint "commercial_id"
    t.bigint "prestation_id"
    t.float "unit_price"
    t.float "quantity"
    t.string "unit"
    t.integer "days"
    t.integer "order"
    t.text "description"
    t.boolean "has_description"
    t.boolean "has_reduction"
    t.integer "reduction_unit"
    t.float "reduction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payment_methods", force: :cascade do |t|
    t.bigint "commercial_id"
    t.date "deadline_regle"
    t.date "delai_regle"
    t.integer "discount_type"
    t.integer "payment_mode"
    t.string "bank_transfer_reference"
    t.float "paid_amount"
    t.date "paid_amount_date"
    t.integer "payment_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "authentication_token"
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.bigint "company_id", null: false
    t.string "job"
    t.integer "role"
    t.integer "platform"
    t.string "photo"
    t.boolean "active"
    t.string "btp"
    t.string "cin"
    t.string "rib"
    t.string "driving_license"
    t.string "type"
    t.string "address"
    t.boolean "is_driver"
    t.boolean "is_teamleader"
    t.float "lat"
    t.float "long"
    t.integer "match_ia"
    t.string "identifier"
    t.float "current_position_lat"
    t.float "current_position_long"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
