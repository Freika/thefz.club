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

ActiveRecord::Schema.define(version: 2020_10_29_201652) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ads", force: :cascade do |t|
    t.text "content"
    t.string "username"
    t.integer "author_telegram_id"
    t.boolean "approved", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_telegram_id"], name: "index_ads_on_author_telegram_id"
    t.index ["username"], name: "index_ads_on_username"
  end

  create_table "moderators", force: :cascade do |t|
    t.integer "telegram_id"
    t.string "username"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["telegram_id"], name: "index_moderators_on_telegram_id"
    t.index ["username"], name: "index_moderators_on_username"
  end

  create_table "owners", force: :cascade do |t|
    t.string "username"
    t.integer "telegram_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["telegram_id"], name: "index_owners_on_telegram_id"
    t.index ["username"], name: "index_owners_on_username"
  end

end
