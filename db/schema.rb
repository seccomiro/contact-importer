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

ActiveRecord::Schema.define(version: 2021_04_29_135635) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.date "birthdate"
    t.string "phone"
    t.string "address"
    t.bigint "user_id", null: false
    t.bigint "credit_card_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["credit_card_id"], name: "index_contacts_on_credit_card_id"
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  create_table "credit_cards", force: :cascade do |t|
    t.string "number"
    t.string "franchise"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "import_contacts", force: :cascade do |t|
    t.bigint "import_id", null: false
    t.string "error_message"
    t.string "name"
    t.string "email"
    t.string "birthdate"
    t.string "phone"
    t.string "address"
    t.string "credit_card_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["import_id"], name: "index_import_contacts_on_import_id"
  end

  create_table "imports", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "file"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "headers"
    t.index ["user_id"], name: "index_imports_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "contacts", "credit_cards"
  add_foreign_key "contacts", "users"
  add_foreign_key "import_contacts", "imports"
  add_foreign_key "imports", "users"
end
