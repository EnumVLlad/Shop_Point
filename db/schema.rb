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

ActiveRecord::Schema[8.1].define(version: 2026_05_21_073409) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "tiers", force: :cascade do |t|
    t.integer "bonus_rate", default: 1, null: false
    t.datetime "created_at", null: false
    t.integer "min_points", default: 0, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tiers_on_name", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description", null: false
    t.decimal "eligible_amount", precision: 10, scale: 2
    t.datetime "expired_at"
    t.string "order_number"
    t.integer "points", default: 0, null: false
    t.decimal "purchase_amount", precision: 10, scale: 2
    t.integer "redeemed_points", default: 0, null: false
    t.string "source", default: "purchase", null: false
    t.string "status", default: "Completed", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["created_at"], name: "index_transactions_on_created_at"
    t.index ["expired_at"], name: "index_transactions_on_expired_at"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "points_balance", default: 0, null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0, null: false
    t.bigint "tier_id"
    t.integer "tier_points", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["tier_id"], name: "index_users_on_tier_id"
  end

  add_foreign_key "transactions", "users"
  add_foreign_key "users", "tiers"
end
