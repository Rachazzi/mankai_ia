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

ActiveRecord::Schema[7.1].define(version: 2025_06_05_190833) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chats", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.bigint "manga_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "model_id"
    t.index ["manga_id"], name: "index_chats_on_manga_id"
    t.index ["user_id"], name: "index_chats_on_user_id"
  end

  create_table "mangakais", force: :cascade do |t|
    t.integer "jikan_id"
    t.string "title"
    t.string "title_english"
    t.text "synopsis"
    t.string "status"
    t.decimal "score"
    t.integer "chapters"
    t.integer "volumes"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mangas", force: :cascade do |t|
    t.string "title"
    t.integer "volumes"
    t.integer "chapters"
    t.text "synopsis_old"
    t.string "image_url"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "system_prompt"
    t.integer "jikan_id", null: false
    t.string "title_english"
    t.string "genre"
    t.text "synopsis"
    t.decimal "score", precision: 3, scale: 1
    t.index ["jikan_id"], name: "index_mangas_on_jikan_id", unique: true
    t.index ["score"], name: "index_mangas_on_score"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "chat_id"
    t.string "model_id"
    t.integer "input_tokens"
    t.integer "output_tokens"
    t.bigint "tool_call_id"
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["tool_call_id"], name: "index_messages_on_tool_call_id"
  end

  create_table "tool_calls", force: :cascade do |t|
    t.bigint "message_id", null: false
    t.string "tool_call_id"
    t.string "name"
    t.jsonb "arguments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_tool_calls_on_message_id"
    t.index ["tool_call_id"], name: "index_tool_calls_on_tool_call_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "chats", "mangas"
  add_foreign_key "chats", "users"
  add_foreign_key "messages", "chats"
  add_foreign_key "messages", "tool_calls"
  add_foreign_key "tool_calls", "messages"
end
