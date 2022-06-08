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

ActiveRecord::Schema.define(version: 2022_04_08_151339) do

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "app_sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "start_time", null: false
    t.integer "duration", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_app_sessions_on_user_id"
  end

  create_table "candidates", force: :cascade do |t|
    t.bigint "uid", null: false
    t.string "full_name"
    t.string "location"
    t.float "latitude"
    t.float "longitude"
    t.text "bio"
    t.string "industry"
    t.string "email"
    t.string "linked_in_url"
    t.string "avatar_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "sex_guess"
    t.integer "ethnicity_guess", default: 0, null: false
    t.index ["email"], name: "index_candidates_on_email"
    t.index ["linked_in_url"], name: "index_candidates_on_linked_in_url"
    t.index ["location"], name: "index_candidates_on_location"
    t.index ["uid"], name: "index_candidates_on_uid", unique: true
  end

  create_table "companies", force: :cascade do |t|
    t.bigint "uid", null: false
    t.string "name"
    t.string "location"
    t.string "industry"
    t.string "website"
    t.integer "founded"
    t.text "bio"
    t.integer "employees_count"
    t.string "linked_in_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "logo_url"
    t.index ["linked_in_url"], name: "index_companies_on_linked_in_url", unique: true
    t.index ["uid"], name: "index_companies_on_uid", unique: true
  end

  create_table "educations", force: :cascade do |t|
    t.bigint "candidate_id", null: false
    t.bigint "uid", null: false
    t.string "school_name"
    t.string "degree"
    t.integer "start_month"
    t.integer "start_year"
    t.integer "end_month"
    t.integer "end_year"
    t.text "description"
    t.text "activities_and_societies"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "school_url"
    t.index ["candidate_id"], name: "index_educations_on_candidate_id"
    t.index ["uid"], name: "index_educations_on_uid", unique: true
  end

  create_table "experiences", force: :cascade do |t|
    t.bigint "candidate_id", null: false
    t.bigint "uid", null: false
    t.string "title"
    t.string "employment_type"
    t.string "company_name"
    t.string "company_linked_in_url"
    t.string "location"
    t.float "latitude"
    t.float "longitude"
    t.integer "start_month"
    t.integer "start_year"
    t.integer "end_month"
    t.integer "end_year"
    t.text "description"
    t.string "media_urls", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "company_id"
    t.index ["candidate_id"], name: "index_experiences_on_candidate_id"
    t.index ["company_id"], name: "index_experiences_on_company_id"
    t.index ["uid"], name: "index_experiences_on_uid", unique: true
  end

  create_table "pipelines", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_pipelines_on_user_id"
  end

  create_table "saved_candidates", force: :cascade do |t|
    t.bigint "pipeline_id", null: false
    t.bigint "candidate_id", null: false
    t.text "assessment"
    t.text "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["candidate_id"], name: "index_saved_candidates_on_candidate_id"
    t.index ["pipeline_id", "candidate_id"], name: "index_saved_candidates_on_pipeline_id_and_candidate_id", unique: true
    t.index ["pipeline_id"], name: "index_saved_candidates_on_pipeline_id"
  end

  create_table "search_performeds", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "query"
    t.json "filters", default: {}
    t.integer "page"
    t.integer "per_page"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_search_performeds_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "auth_token", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "mogul_id"
    t.integer "company_id"
    t.string "company_name"
    t.index "lower((email)::text)", name: "index_users_on_lowercase_email", unique: true
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true
    t.index ["mogul_id"], name: "index_users_on_mogul_id", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "app_sessions", "users", on_delete: :cascade
  add_foreign_key "educations", "candidates", on_delete: :cascade
  add_foreign_key "experiences", "candidates", on_delete: :cascade
  add_foreign_key "experiences", "companies"
  add_foreign_key "pipelines", "users", on_delete: :cascade
  add_foreign_key "saved_candidates", "candidates", on_delete: :cascade
  add_foreign_key "saved_candidates", "pipelines", on_delete: :cascade
  add_foreign_key "search_performeds", "users"
  add_foreign_key "users", "users", column: "company_id"
end
