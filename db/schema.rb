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

ActiveRecord::Schema[8.0].define(version: 2025_03_08_081843) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "unaccent"
  enable_extension "uuid-ossp"

  create_table "absences", force: :cascade do |t|
    t.bigint "user_id"
    t.date "date_start"
    t.date "date_end"
    t.text "motif"
    t.integer "type_absence", default: 0
    t.string "document"
    t.integer "state", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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

  create_table "boards", force: :cascade do |t|
    t.string "title"
    t.integer "order"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "client_contacts", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.bigint "contact_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "column_items", force: :cascade do |t|
    t.string "title"
    t.integer "order"
    t.bigint "board_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id"], name: "index_column_items_on_board_id"
  end

  create_table "commercial_contacts", force: :cascade do |t|
    t.bigint "commercial_id", null: false
    t.bigint "contact_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commercial_id"], name: "index_commercial_contacts_on_commercial_id"
    t.index ["contact_id"], name: "index_commercial_contacts_on_contact_id"
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

  create_table "contacts", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "email"
    t.string "job"
    t.string "tags"
    t.integer "role"
    t.string "company_name"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "documents", force: :cascade do |t|
    t.integer "document_type", null: false
    t.date "expiration_date"
    t.integer "document_status"
    t.text "notice"
    t.string "documentable_type", null: false
    t.bigint "documentable_id", null: false
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["documentable_type", "documentable_id"], name: "index_documents_on_documentable"
  end

  create_table "email_models", force: :cascade do |t|
    t.text "subject"
    t.text "body"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_email_models_on_company_id"
  end

  create_table "headings", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "interventions", force: :cascade do |t|
    t.bigint "client_id"
    t.bigint "user_id"
    t.bigint "heading_id"
    t.bigint "company_id"
    t.boolean "is_closed", default: false
    t.boolean "display_heading", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_interventions_on_client_id"
    t.index ["company_id"], name: "index_interventions_on_company_id"
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

  create_table "materials", force: :cascade do |t|
    t.string "type"
    t.text "notes"
    t.string "name"
    t.string "reference"
    t.string "serial_number"
    t.boolean "is_active"
    t.string "picture"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mention_legals", force: :cascade do |t|
    t.string "name"
    t.text "description"
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

  create_table "planning_agents", force: :cascade do |t|
    t.bigint "schedule_id", null: false
    t.bigint "agent_id"
    t.bigint "vehicle_id"
    t.time "start_at"
    t.time "finish_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["schedule_id"], name: "index_planning_agents_on_schedule_id"
  end

  create_table "planning_contacts", force: :cascade do |t|
    t.bigint "planning_id", null: false
    t.bigint "contact_id", null: false
    t.integer "contact_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_planning_contacts_on_contact_id"
    t.index ["planning_id"], name: "index_planning_contacts_on_planning_id"
  end

  create_table "planning_materials", force: :cascade do |t|
    t.integer "quantity", default: 1, null: false
    t.bigint "planning_id", null: false
    t.bigint "material_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["material_id"], name: "index_planning_materials_on_material_id"
    t.index ["planning_id"], name: "index_planning_materials_on_planning_id"
  end

  create_table "planning_photos", force: :cascade do |t|
    t.string "imageable_type", null: false
    t.bigint "imageable_id", null: false
    t.integer "photo_type"
    t.integer "before_after"
    t.bigint "linked_photo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["imageable_type", "imageable_id"], name: "index_planning_photos_on_imageable"
    t.index ["linked_photo_id"], name: "index_planning_photos_on_linked_photo_id"
  end

  create_table "planning_report_photos", force: :cascade do |t|
    t.bigint "planning_id", null: false
    t.integer "position"
    t.bigint "parent_id"
    t.string "photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["planning_id"], name: "index_planning_report_photos_on_planning_id"
  end

  create_table "planning_subcontractor_agents", force: :cascade do |t|
    t.bigint "planning_subcontractor_id", null: false
    t.bigint "subcontractor_agent_id", null: false
    t.boolean "sms_delivered", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["planning_subcontractor_id"], name: "idx_on_planning_subcontractor_id_4d49b52559"
    t.index ["subcontractor_agent_id"], name: "index_planning_subcontractor_agents_on_subcontractor_agent_id"
  end

  create_table "planning_subcontractors", force: :cascade do |t|
    t.bigint "schedule_id", null: false
    t.bigint "subcontractor_id", null: false
    t.integer "agent_needed"
    t.boolean "include_contact"
    t.boolean "send_email"
    t.boolean "send_sms"
    t.text "needs"
    t.text "remark"
    t.text "note"
    t.float "rate_mission"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["schedule_id"], name: "index_planning_subcontractors_on_schedule_id"
    t.index ["subcontractor_id"], name: "index_planning_subcontractors_on_subcontractor_id"
  end

  create_table "planning_tasks", force: :cascade do |t|
    t.bigint "prestation_id", null: false
    t.bigint "planning_id", null: false
    t.time "started_at"
    t.time "finished_at"
    t.text "description"
    t.date "date"
    t.integer "state"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["planning_id"], name: "index_planning_tasks_on_planning_id"
    t.index ["prestation_id"], name: "index_planning_tasks_on_prestation_id"
  end

  create_table "planning_vehicles", force: :cascade do |t|
    t.bigint "planning_id", null: false
    t.bigint "vehicle_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["planning_id"], name: "index_planning_vehicles_on_planning_id"
    t.index ["vehicle_id"], name: "index_planning_vehicles_on_vehicle_id"
  end

  create_table "plannings", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.bigint "intervention_id", null: false
    t.bigint "prestation_id", null: false
    t.bigint "user_id"
    t.bigint "quote_id"
    t.bigint "bill_id"
    t.integer "agent_needed"
    t.boolean "manual_dispatch"
    t.boolean "include_vehicle"
    t.boolean "invoiced_agent"
    t.boolean "invoiced_truck"
    t.text "needs"
    t.text "note"
    t.text "remark"
    t.bigint "mattermost_id"
    t.string "mattermost_channel_name"
    t.string "type"
    t.date "start_on"
    t.date "finish_on"
    t.jsonb "intervention_days", default: {}
    t.bigint "parent_id"
    t.integer "status"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_plannings_on_client_id"
    t.index ["company_id"], name: "index_plannings_on_company_id"
    t.index ["intervention_id"], name: "index_plannings_on_intervention_id"
    t.index ["prestation_id"], name: "index_plannings_on_prestation_id"
  end

  create_table "pointing_internals", force: :cascade do |t|
    t.bigint "planning_agent_id", null: false
    t.time "started_on"
    t.time "finished_on"
    t.boolean "is_valide"
    t.float "rate_lunch"
    t.float "overtime"
    t.bigint "validate_by"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["planning_agent_id"], name: "index_pointing_internals_on_planning_agent_id"
  end

  create_table "prestations", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "remark"
    t.string "alias"
    t.decimal "price"
    t.string "unity"
    t.integer "type_prestation"
    t.integer "state"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "planning_id", null: false
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["planning_id"], name: "index_schedules_on_planning_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "name"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_skills_on_company_id"
  end

  create_table "subcontractor_skills", force: :cascade do |t|
    t.bigint "subcontractor_id", null: false
    t.bigint "skill_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skill_id"], name: "index_subcontractor_skills_on_skill_id"
    t.index ["subcontractor_id"], name: "index_subcontractor_skills_on_subcontractor_id"
  end

  create_table "subcontractor_users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "email"
    t.string "post"
    t.string "type"
    t.boolean "is_archived"
    t.bigint "address_id"
    t.bigint "subcontractor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subcontractor_id"], name: "index_subcontractor_users_on_subcontractor_id"
  end

  create_table "subcontractors", force: :cascade do |t|
    t.string "company_name"
    t.string "manager"
    t.string "email"
    t.string "phone"
    t.boolean "active", default: true
    t.string "color"
    t.string "logo"
    t.string "siret"
    t.string "speciality"
    t.float "rate_agent"
    t.float "rate_mission"
    t.bigint "address_id"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "order"
    t.date "delivery_date"
    t.integer "priority"
    t.bigint "column_item_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_skills", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "skill_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skill_id"], name: "index_user_skills_on_skill_id"
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
    t.bigint "company_id"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "license_plate"
    t.string "brand"
    t.string "model"
    t.string "color"
    t.date "last_technical_inspection_date"
    t.boolean "insured"
    t.date "insurance_end_date"
    t.boolean "in_circulation"
    t.text "comments"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "column_items", "boards"
  add_foreign_key "commercial_contacts", "commercials"
  add_foreign_key "commercial_contacts", "contacts"
  add_foreign_key "planning_agents", "schedules"
  add_foreign_key "planning_contacts", "contacts"
  add_foreign_key "planning_contacts", "plannings"
  add_foreign_key "planning_materials", "materials"
  add_foreign_key "planning_materials", "plannings"
  add_foreign_key "planning_report_photos", "plannings"
  add_foreign_key "planning_subcontractor_agents", "planning_subcontractors"
  add_foreign_key "planning_subcontractor_agents", "subcontractor_users", column: "subcontractor_agent_id"
  add_foreign_key "planning_subcontractors", "schedules"
  add_foreign_key "planning_subcontractors", "subcontractors"
  add_foreign_key "planning_tasks", "plannings"
  add_foreign_key "planning_tasks", "prestations"
  add_foreign_key "planning_vehicles", "plannings"
  add_foreign_key "planning_vehicles", "vehicles"
  add_foreign_key "plannings", "clients"
  add_foreign_key "plannings", "interventions"
  add_foreign_key "plannings", "prestations"
  add_foreign_key "pointing_internals", "planning_agents"
  add_foreign_key "schedules", "plannings"
  add_foreign_key "subcontractor_skills", "skills"
  add_foreign_key "subcontractor_skills", "subcontractors"
  add_foreign_key "subcontractor_users", "subcontractors"
  add_foreign_key "user_skills", "skills"
  add_foreign_key "users", "companies"
end
