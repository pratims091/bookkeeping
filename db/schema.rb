# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_09_195941) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "transactions", force: :cascade do |t|
    t.string "transaction_type", null: false
    t.bigint "user_id", null: false
    t.bigint "contact_id"
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.date "happend_on", null: false
    t.text "comments"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contact_id"], name: "index_transactions_on_contact_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "user_contacts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "contact_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contact_id"], name: "index_user_contacts_on_contact_id"
    t.index ["user_id", "contact_id"], name: "index_user_contacts_on_user_id_and_contact_id", unique: true
    t.index ["user_id"], name: "index_user_contacts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "phone_number", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_users_on_name"
    t.index ["phone_number"], name: "index_users_on_phone_number", unique: true
  end

  add_foreign_key "transactions", "users"
  add_foreign_key "transactions", "users", column: "contact_id"
  add_foreign_key "user_contacts", "users"
  add_foreign_key "user_contacts", "users", column: "contact_id"
end
