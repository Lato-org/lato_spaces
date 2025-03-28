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

ActiveRecord::Schema[8.0].define(version: 2024_11_30_102735) do
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

  create_table "lato_invitations", force: :cascade do |t|
    t.string "email"
    t.datetime "accepted_at"
    t.string "accepted_code"
    t.integer "lato_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "inviter_lato_user_id"
    t.index ["inviter_lato_user_id"], name: "index_lato_invitations_on_inviter_lato_user_id"
    t.index ["lato_user_id"], name: "index_lato_invitations_on_lato_user_id"
  end

  create_table "lato_log_user_signins", force: :cascade do |t|
    t.string "ip_address"
    t.string "user_agent"
    t.integer "lato_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lato_user_id"], name: "index_lato_log_user_signins_on_lato_user_id"
  end

  create_table "lato_log_user_signups", force: :cascade do |t|
    t.string "ip_address"
    t.string "user_agent"
    t.integer "lato_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lato_user_id"], name: "index_lato_log_user_signups_on_lato_user_id"
  end

  create_table "lato_operations", force: :cascade do |t|
    t.string "active_job_name"
    t.json "active_job_input"
    t.json "active_job_output"
    t.integer "status"
    t.integer "percentage"
    t.datetime "closed_at"
    t.integer "lato_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lato_user_id"], name: "index_lato_operations_on_lato_user_id"
  end

  create_table "lato_spaces_associations", force: :cascade do |t|
    t.integer "lato_spaces_group_id"
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_type", "item_id"], name: "index_lato_spaces_associations_on_item"
    t.index ["lato_spaces_group_id"], name: "index_lato_spaces_associations_on_lato_spaces_group_id"
  end

  create_table "lato_spaces_groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lato_spaces_memberships", force: :cascade do |t|
    t.integer "lato_spaces_group_id"
    t.integer "lato_user_id"
    t.integer "lato_invitation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "preferred", default: false
    t.index ["lato_invitation_id"], name: "index_lato_spaces_memberships_on_lato_invitation_id"
    t.index ["lato_spaces_group_id"], name: "index_lato_spaces_memberships_on_lato_spaces_group_id"
    t.index ["lato_user_id"], name: "index_lato_spaces_memberships_on_lato_user_id"
  end

  create_table "lato_users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "email_verified_at"
    t.string "password_digest"
    t.integer "accepted_privacy_policy_version"
    t.integer "accepted_terms_and_conditions_version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "locale"
    t.boolean "lato_spaces_admin", default: false
    t.string "web3_address"
    t.string "authenticator_secret"
    t.index ["email"], name: "index_lato_users_on_email", unique: true
  end

  create_table "product_requireds", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_uniques", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "lato_invitations", "lato_users"
  add_foreign_key "lato_invitations", "lato_users", column: "inviter_lato_user_id"
  add_foreign_key "lato_log_user_signins", "lato_users"
  add_foreign_key "lato_log_user_signups", "lato_users"
  add_foreign_key "lato_operations", "lato_users"
  add_foreign_key "lato_spaces_associations", "lato_spaces_groups"
  add_foreign_key "lato_spaces_memberships", "lato_invitations"
  add_foreign_key "lato_spaces_memberships", "lato_spaces_groups"
  add_foreign_key "lato_spaces_memberships", "lato_users"
end
