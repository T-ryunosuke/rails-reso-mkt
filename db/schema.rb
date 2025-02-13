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

ActiveRecord::Schema[7.2].define(version: 2025_02_13_023308) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cities", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "interests", force: :cascade do |t|
    t.bigint "price_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["price_id"], name: "index_interests_on_price_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_items_on_name"
  end

  create_table "prices", force: :cascade do |t|
    t.bigint "city_id", null: false
    t.bigint "item_id", null: false
    t.integer "price_percentage", null: false
    t.boolean "trend", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_prices_on_city_id"
    t.index ["item_id"], name: "index_prices_on_item_id"
    t.index ["updated_at", "price_percentage"], name: "index_prices_on_updated_at_and_price_percentage", order: :desc
  end

  add_foreign_key "interests", "prices"
  add_foreign_key "prices", "cities"
  add_foreign_key "prices", "items"
end
