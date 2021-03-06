# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20200507093620) do

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "goalsets", force: :cascade do |t|
    t.integer "user_id"
    t.string "mission"
    t.string "short_goal"
    t.datetime "s_goal_deadline_at"
    t.string "middle_goal"
    t.datetime "m_goal_deadline_at"
    t.string "long_goal"
    t.datetime "l_goal_deadline_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "mission_set_at"
    t.datetime "s_goal_set_at"
    t.datetime "m_goal_set_at"
    t.datetime "l_goal_set_at"
    t.index ["user_id"], name: "index_goalsets_on_user_id"
  end

  create_table "linebots", force: :cascade do |t|
    t.integer "user_id"
    t.string "line_uid"
    t.integer "valid_flag"
    t.integer "week1_flag"
    t.integer "week2_flag"
    t.integer "week3_flag"
    t.integer "week4_flag"
    t.integer "week5_flag"
    t.integer "week6_flag"
    t.integer "week7_flag"
    t.datetime "dotime_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_linebots_on_user_id"
  end

  create_table "memopads", force: :cascade do |t|
    t.integer "user_id"
    t.string "title"
    t.string "memo"
    t.integer "orderno"
    t.integer "delflag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_memopads_on_user_id"
  end

  create_table "todolists", force: :cascade do |t|
    t.integer "user_id"
    t.string "todo"
    t.datetime "start_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "delflag"
    t.index ["user_id"], name: "index_todolists_on_user_id"
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
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "username"
    t.integer "admin_flag"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

end
