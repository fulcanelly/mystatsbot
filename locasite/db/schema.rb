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

ActiveRecord::Schema[7.0].define(version: 2023_05_22_003044) do
  create_table "chats", force: :cascade do |t|
    t.string "first_name"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_deleted", default: false
  end

  create_table "days", force: :cascade do |t|
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_days_on_date", unique: true
  end

  create_table "tg_posts", force: :cascade do |t|
    t.integer "day_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "chat_id"
    t.string "message_id"
    t.index ["chat_id", "message_id"], name: "index_tg_posts_on_chat_id_and_message_id", unique: true
    t.index ["day_id"], name: "index_tg_posts_on_day_id"
  end

  add_foreign_key "tg_posts", "days"

  create_view "my_day_message_count_per_chats", sql_definition: <<-SQL
      SELECT
      chats.id as chat_id,
      chats.first_name,
      chats.username,
      chats.is_deleted,
      days.date,
      COUNT(tg_posts.id) AS post_count
  FROM chats
  INNER JOIN tg_posts ON tg_posts.chat_id = chats.id
  INNER JOIN days ON days.id = tg_posts.day_id
  GROUP BY chats.id, days.date
  ORDER BY post_count DESC
  SQL
end
